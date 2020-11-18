DELETE FROM `job_grades` WHERE `job_name` = 'offpolice';
DELETE FROM `job_grades` WHERE `job_name` = 'police';

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('police', 8, 'commissioner', 'Commissioner', 700, '{}', '{}'),
('offpolice', 8, 'commissioner', 'Commissioner (Off Duty)', 150, '{}', '{}'),
('police', 7, 'chief', 'Chief of Police', 700, '{}', '{}'),
('offpolice', 7, 'chief', 'Chief of Police (Off Duty)', 150, '{}', '{}'),
('police', 6, 'asstchief', 'Asst. Chief of Police', 700, '{}', '{}'),
('offpolice', 6, 'asstchief', 'Asst. Chief of Police (Off Duty)', 150, '{}', '{}'),
('police', 5, 'captain', 'Captain', 650, '{}', '{}'),
('offpolice', 5, 'captain', 'Captain (Off Duty)', 150, '{}', '{}'),
('police', 4, 'lieutenant', 'Lieutenant', 600, '{}', '{}'),
('offpolice', 4, 'lieutenant', 'Lieutenant (Off Duty)', 150, '{}', '{}'),
('police', 3, 'sergeant', 'Sergeant', 550, '{}', '{}'),
('offpolice', 3, 'sergeant', 'Sergeant (Off Duty)', 150, '{}', '{}'),
('police', 2, 'seniorofficer', 'Senior Officer', 500, '{}', '{}'),
('offpolice', 2, 'seniorofficer', 'Senior Officer (Off Duty)', 150, '{}', '{}'),
('police', 1, 'patrolofficer', 'Patrol Officer', 450, '{}', '{}'),
('offpolice', 1, 'patrolofficer', 'Patrol Officer (Off Duty)', 150, '{}', '{}'),
('police', 0, 'cadet', 'Cadet', 400, '{}', '{}'),
('offpolice', 0, 'cadet', 'Cadet (Off Duty)', 150, '{}', '{}');