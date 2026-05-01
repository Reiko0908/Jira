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