-- Step 1: Create HospitalStaff Table (self-referencing for hierarchy)
CREATE TABLE HospitalStaff (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(100),
    role VARCHAR(50),            -- e.g., Department, Unit, Doctor
    parent_id INT,               -- references department/unit parent
    FOREIGN KEY (parent_id) REFERENCES HospitalStaff(staff_id)
);

-- Step 2: Create PatientCases Table
CREATE TABLE PatientCases (
    case_id INT PRIMARY KEY,
    doctor_id INT,
    patient_name VARCHAR(100),
    case_date DATE,
    FOREIGN KEY (doctor_id) REFERENCES HospitalStaff(staff_id)
);

-- Step 3: Insert Sample Staff Hierarchy Data
INSERT INTO HospitalStaff VALUES
(1, 'General Medicine', 'Department', NULL),
(2, 'Cardiology', 'Department', NULL),
(3, 'GM Unit A', 'Unit', 1),
(4, 'GM Unit B', 'Unit', 1),
(5, 'Cardio Unit A', 'Unit', 2),
(6, 'Dr. Arjun', 'Doctor', 3),
(7, 'Dr. Bhavna', 'Doctor', 4),
(8, 'Dr. Charu', 'Doctor', 5),
(9, 'Dr. Dev', 'Doctor', 3);

-- Step 4: Insert Sample Patient Case Data
INSERT INTO PatientCases VALUES
(101, 6, 'Patient X', '2025-07-01'),
(102, 6, 'Patient Y', '2025-07-02'),
(103, 7, 'Patient Z', '2025-07-03'),
(104, 8, 'Patient A', '2025-07-04'),
(105, 8, 'Patient B', '2025-07-05'),
(106, 9, 'Patient C', '2025-07-01'),
(107, 9, 'Patient D', '2025-07-02'),
(108, 9, 'Patient E', '2025-07-03');

-- Step 5: Recursive CTE to Build Staff Hierarchy
WITH RECURSIVE StaffTree AS (
    SELECT 
        staff_id,
        staff_name,
        role,
        parent_id,
        1 AS depth,
        CAST(staff_name AS VARCHAR(1000)) AS path
    FROM HospitalStaff
    WHERE parent_id IS NULL

    UNION ALL

    SELECT 
        hs.staff_id,
        hs.staff_name,
        hs.role,
        hs.parent_id,
        st.depth + 1,
        CONCAT(st.path, ' → ', hs.staff_name)
    FROM HospitalStaff hs
    JOIN StaffTree st ON hs.parent_id = st.staff_id
),

-- Step 6: Count Patient Cases with Window Functions
WorkloadData AS (
    SELECT 
        hs.staff_id,
        hs.staff_name,
        hs.role,
        st.path,
        st.depth,
        COUNT(pc.case_id) OVER(PARTITION BY hs.staff_id) AS case_count_doctor,
        COUNT(pc.case_id) OVER(PARTITION BY hs.parent_id) AS case_count_unit,
        COUNT(pc.case_id) OVER(PARTITION BY st.parent_id) AS case_count_department
    FROM HospitalStaff hs
    LEFT JOIN PatientCases pc ON hs.staff_id = pc.doctor_id
    LEFT JOIN StaffTree st ON hs.staff_id = st.staff_id
)

-- Step 7: Create View for Workload Reporting
CREATE VIEW DepartmentalWorkloadView AS
SELECT 
    staff_id,
    staff_name,
    role,
    path,
    depth,
    COALESCE(case_count_doctor, 0) AS doctor_cases,
    COALESCE(case_count_unit, 0) AS unit_cases,
    COALESCE(case_count_department, 0) AS department_cases
FROM WorkloadData;