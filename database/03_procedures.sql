-- ============================================================
-- sp_assert_profile_exists
--    Validates that a ProfileID exists in UserProfile.
-- ============================================================
DROP PROCEDURE IF EXISTS sp_assert_profile_exists;
DELIMITER $$
CREATE PROCEDURE sp_assert_profile_exists(
    IN  p_ProfileID   INT,
    IN  p_role_label  VARCHAR(30)   -- e.g. 'Reporter', 'Assignee'
)
BEGIN
    DECLARE v_found TINYINT DEFAULT 0;
    SELECT COUNT(*) INTO v_found
    FROM   UserProfile
    WHERE  ProfileID = p_ProfileID;

    IF v_found = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Profile not found. Please provide a valid ProfileID for this role.';
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- 1. sp_create_task
--    Creates a new Task row after validating every constraint.
-- ============================================================
DROP PROCEDURE IF EXISTS sp_create_task;
DELIMITER $$
CREATE PROCEDURE sp_create_task(
    IN  p_Title         VARCHAR(50),
    IN  p_Description   VARCHAR(255),
    IN  p_Priority      INT,            -- 0 = None, 1 = Low, 2 = Medium, 3 = High, 4 = Critical
    IN  p_DueDate       TIMESTAMP,      -- NULL is allowed
    IN  p_ParentTaskID  INT,            -- NULL = top-level task
    IN  p_StatusID      INT,            -- must exist in TaskStatus
    IN  p_MilestoneID   INT,            -- NULL allowed
    IN  p_ReporterID    INT,            -- must be an existing profile
    IN  p_AssigneeID    INT,            -- NULL allowed; if set must be an existing profile
    IN  p_BoardID       INT,            -- NULL allowed
    OUT p_NewTaskID     INT
)
BEGIN
    DECLARE v_workflow_id       INT;
    DECLARE v_milestone_status  VARCHAR(15);
    DECLARE v_parent_type       VARCHAR(10);  -- 'Epic','Story','Bug','Subtask'
    DECLARE v_status_workflow   INT;
    DECLARE v_board_project_id  INT;

    -- ── 1. Title must not be blank ────────────────────────────
    IF p_Title IS NULL OR CHAR_LENGTH(TRIM(p_Title)) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Task title must not be empty.';
    END IF;

    -- ── 2. Priority range check ───────────────────────────────
    IF p_Priority IS NOT NULL AND p_Priority NOT IN (0, 1, 2, 3, 4) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Task priority must be 0 (None), 1 (Low), 2 (Medium), 3 (High), or 4 (Critical).';
    END IF;

    -- ── 3. DueDate must not be in the past ───────────────────
    IF p_DueDate IS NOT NULL AND p_DueDate < NOW() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Due date must not be set to a date in the past.';
    END IF;

    -- ── 4. Reporter must exist ────────────────────────────────
    CALL sp_assert_profile_exists(p_ReporterID, 'Reporter');

    -- ── 5. Assignee (if provided) must exist ──────────────────
    IF p_AssigneeID IS NOT NULL THEN
        CALL sp_assert_profile_exists(p_AssigneeID, 'Assignee');
    END IF;

    -- ── 6. StatusID must exist ────────────────────────────────
    IF p_StatusID IS NOT NULL THEN
        SELECT WorkflowID INTO v_status_workflow
        FROM   TaskStatus
        WHERE  StatusID = p_StatusID
        LIMIT  1;

        IF v_status_workflow IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'StatusID does not exist in TaskStatus.';
        END IF;
    END IF;

    -- ── 7. MilestoneID: milestone must not be closed ─────────
    IF p_MilestoneID IS NOT NULL THEN
        SELECT MilestoneStatus INTO v_milestone_status
        FROM   Milestone
        WHERE  MilestoneID = p_MilestoneID
        LIMIT  1;

        IF v_milestone_status IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'MilestoneID does not exist.';
        END IF;
        IF v_milestone_status = 'Closed' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Cannot assign a task to a closed milestone.';
        END IF;
    END IF;

    -- ── 8. ParentTask hierarchy rules ────────────────────────
    --   Epic  → children may be Story or Bug
    --   Story → children may only be Subtask (plain Task with no Epic/Story/Bug row)
    --   Bug   → cannot have children
    --   Subtask → cannot have children
    IF p_ParentTaskID IS NOT NULL THEN
        -- Check the parent exists
        IF NOT EXISTS (SELECT 1 FROM Task WHERE TaskID = p_ParentTaskID) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Parent task does not exist.';
        END IF;

        -- Determine parent type
        IF EXISTS (SELECT 1 FROM Epic  WHERE TaskID = p_ParentTaskID) THEN
            SET v_parent_type = 'Epic';
        ELSEIF EXISTS (SELECT 1 FROM Story WHERE TaskID = p_ParentTaskID) THEN
            SET v_parent_type = 'Story';
        ELSEIF EXISTS (SELECT 1 FROM Bug   WHERE TaskID = p_ParentTaskID) THEN
            SET v_parent_type = 'Bug';
        ELSE
            SET v_parent_type = 'Subtask';
        END IF;

        IF v_parent_type = 'Bug' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A Bug task cannot have child tasks.';
        END IF;
        IF v_parent_type = 'Subtask' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A Subtask (plain task) cannot have child tasks.';
        END IF;
    END IF;

    -- ── 9. BoardID must exist (if provided) ──────────────────
    IF p_BoardID IS NOT NULL THEN
        SELECT ProjectID INTO v_board_project_id
        FROM   Board
        WHERE  BoardID = p_BoardID
        LIMIT  1;

        IF v_board_project_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'The provided BoardID does not exist.';
        END IF;
    END IF;

    -- ── All checks passed → INSERT ────────────────────────────
    INSERT INTO Task (
        Title, TaskDescription, TaskPriority,
        DueDate, ParentTaskID,
        StatusID, MilestoneID,
        ReporterID, AssigneeID, BoardID
    ) VALUES (
        TRIM(p_Title), p_Description, COALESCE(p_Priority, 0),
        p_DueDate, p_ParentTaskID,
        p_StatusID, p_MilestoneID,
        p_ReporterID, p_AssigneeID, p_BoardID
    );
    SET p_NewTaskID = LAST_INSERT_ID();
END$$
DELIMITER ;