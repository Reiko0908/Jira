INSERT INTO ProjectRole(RoleName)
VALUES
    ('Project Manager'),
    ('Backend Developer'),
    ('Frontend Developer'),
    ('Graphic Designer'),
    ('QA Engineer'),
    ('Marketing Specialist'),
    ('HR Specialist'),
    ('Recruiter');
INSERT INTO Workflow (WorkflowName)
VALUES
    ('Default'), -- ID = 1
    ('Marketing Task'), -- ID = 2
    ('Dev Task'),
    ('Tester Task'),
    ('HR Task');

INSERT INTO TaskStatus (WorkflowID, StatusName, OrderIndex)
VALUES
    -- Default
    (1, 'To Do', 1),
    (1, 'In Progress', 2),
    (1, 'Review', 3),
    (1, 'Done', 4),

    -- Marketing
    (2, 'Idea', 1),
    (2, 'Planning', 2),
    (2, 'Executing', 3),
    (2, 'Done', 4),

    -- Dev
    (3, 'To Do', 1),
    (3, 'In Progress', 2),
    (3, 'Code Review', 3),
    (3, 'Testing', 4),
    (3, 'Done', 5),

    -- Tester
    (4, 'To Test', 1),
    (4, 'Testing', 2),
    (4, 'Bug Found', 3),
    (4, 'Done', 4),

    -- HR
    (5, 'Applied', 1),
    (5, 'Screening', 2),
    (5, 'Interview', 3),
    (5, 'Offer', 4),
    (5, 'Hired', 5),
    (5, 'Rejected', 6);

INSERT INTO Project (
    ProjectName,
    ProjectDescription,
    ProjectStatus,
    FinishedTime,
    OwnerID,
    WorkflowID
)
VALUES
-- 1. E-commerce Platform (Default workflow)
(
    'E-commerce Platform',
    'Development of a scalable multi-vendor e-commerce platform targeting SME retailers in Southeast Asia.
    Scope includes product catalog management, payment gateway integration (Stripe, PayPal), order processing,
    and logistics tracking. Team consists of 1 PM, 5 backend engineers, 3 frontend engineers, and 2 QA engineers.
    Key stakeholders include external retail partners and internal sales team.',
    'In Progress',
    NULL,
    1,
    1
),

-- 2. Marketing Campaign Q1
(
    'Marketing Campaign Q1',
    'Execution of Q1 digital marketing strategy focusing on brand awareness and customer acquisition.
    Channels include Facebook Ads, Google Ads, and email marketing. Deliverables include campaign creatives,
    landing pages, and performance reports. Collaboration between marketing team, design team, and external ad agency.',
    'To Do',
    '2026-03-31',
    1,
    2
),

-- 3. HR Hiring Backend Engineers
(
    'HR - Hiring Backend Engineers',
    'Recruitment drive to hire 5 backend engineers specializing in Java and Spring Boot.
    Process includes job posting, CV screening, technical interviews, and onboarding.
    Coordination between HR team and engineering managers. Target candidates have 2-5 years experience.',
    'To Do',
    '2026-06-18',
    1,
    5
),

-- 4. Mobile Banking App
(
    'Mobile Banking App',
    'Development of a secure mobile banking application for retail customers. Features include account management,
    fund transfers, bill payments, and biometric authentication. Compliance with financial regulations and security
    standards (PCI DSS). Team includes mobile developers, backend engineers, security specialists, and QA.',
    'To Do',
    '2026-12-15',
    1,
    3
),

-- 5. QA Test for Project AC
(
    'QA Test for Project AC',
    'Comprehensive testing phase for Project AC including functional testing, regression testing, and performance testing.
    Test cases are derived from business requirements and system specifications. QA team coordinates closely with developers
    to identify and resolve defects before production release.',
    'In Progress',
    '2026-05-10',
    2,
    4
);


INSERT INTO Milestone
(MilestoneName, MilestoneStatus, MilestoneGoal, StartDate, EndDate)
VALUES
    ('Project Kickoff', 'Completed',
     'Align team on scope, timeline and initial requirements',
     '2026-02-01', '2026-02-04'),

    ('Requirements phase', 'Completed',
     'Requirements elicitation',
     '2026-02-04', '2026-02-15'),

    ('UI/UX design', 'In Progress',
     'Create and iterate UI designs for user flows',
     '2026-05-16', '2026-05-28'),

    ('Core development', 'Not Started',
     'Implement features and deploy product',
     '2026-05-29', '2026-06-20'),

    ('Quality Assurance', 'Not Started',
     'Perform quality control and prepare for release',
     '2026-06-21', '2026-06-30'),

    ('Others', 'In Progress', NULL, NULL, NULL);

INSERT INTO Task (
    Title, TaskDescription, TaskPriority, DueDate,
    StatusID, MilestoneID, ReporterID, AssigneeID, BoardID
)
VALUES
    ('Set up project repository',
     'Initialize Git repository and basic project structure.',
     0,
     '2026-02-02',
     3, 1, 1, 2, 1),

    ('Plan marketing campaign',
     'Define campaign objectives, analyze competitors, and align with budget.',
     'Low',
     '2026-02-03',
     2, 1, 1, 3, 1),

    ('Gather user requirements',
     'Interview stakeholders and collect functional and non-functional requirements.',
     'High',
     '2026-02-08',
     2, 2, 1, 3, 1),

    ('Write SRS document',
     'Compile requirements into a Software Requirements Specification document.',
     'High',
     '2026-02-14',
     2, 2, 1, 2, 1),

    ('Design student interface',
     'Create UI mockups in Figma for dashboard and navigation.',
     'High',
     '2026-05-25',
     1, 3, 1, 2, 1),

    ('Design high-fidelity UI',
     'Produce final UI with components and responsive layouts.',
     'High',
     '2026-05-27',
     2, 3, 1, 2, 1),

    ('Implement authentication module',
     'Develop login, registration, and JWT-based authentication.',
     'High',
     '2026-06-05',
     1, 4, 1, 3, 1),

    ('Implement payment module',
     'Develop payment feature based on technical specification.',
     'High',
     '2026-06-26',
     1, 4, 3, 2, 1),

    ('Write test cases',
     'Prepare unit and integration test cases.',
     'Medium',
     '2026-06-24',
     1, 5, 1, 3, 1),

    ('[URGENT] Fix server error',
     'A new bug appeared on the server. Need to fix this ASAP.',
     'High',
     '2026-06-28',
     2, 5, 1, 3, 1),

    ('Prepare requirements specification',
     'Schedule meetings and refine requirements documentation.',
     'Medium',
     '2026-05-15',
     2, 6, 1, 3, 1);
INSERT INTO LinkedItem (TaskID, LinkedItem)
VALUES
    (2, 'https://www.figma.com/design/ABC'),
    (3, 'https://drive.google.com/drive/ABC/report-template'),
    (5, 'https://github.com/ABC/A-project/event123'),
    (1, 'https://drive.google.com/drive/ABC/technical-specification-document'),
    (4, 'https://forms.google.com/customer-satisfaction-survey');