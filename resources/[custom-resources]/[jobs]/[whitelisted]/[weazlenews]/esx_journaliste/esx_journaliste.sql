INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('reporter', 'Reporter', 1),
('offreporter', 'Reporter', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_journaliste', 'Weazel News', 1);

INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
('society_journaliste', 200000, NULL);

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_journaliste', 'Weazel News', 1);


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('reporter', 0, 'stagiaire', 'Intern', 250, '{}', '{}'),
('reporter', 1, 'reporter', 'Reporter', 350, '{}', '{}'),
('reporter', 2, 'investigator', 'Investigator', 400, '{}', '{}'),
('reporter', 3, 'boss', 'Boss', 450, '{}', '{}'),
('offreporter', 0, 'stagiaire', 'Intern', 250, '{}', '{}'),
('offreporter', 1, 'reporter', 'Reporter', 350, '{}', '{}'),
('offreporter', 2, 'investigator', 'Investigator', 400, '{}', '{}'),
('offreporter', 3, 'boss', 'Boss', 450, '{}', '{}');