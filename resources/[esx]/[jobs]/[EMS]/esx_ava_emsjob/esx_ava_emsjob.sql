USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_ems', 'EMS', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_ems', 'EMS', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_ems', 'EMS', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('ems',0,'employee','Ambulancier', 20, "{}", "{}"),
	('ems',1,'doctor','Medecin', 40, "{}", "{}"),
	('ems',2,'boss','Directeur', 80, "{}", "{}")
;

INSERT INTO `jobs` (name, label) VALUES
	('ems','EMS')
;

INSERT INTO `items` (name, label, `limit`) VALUES
	('bandage','Bandage', 20),
	('medikit','Medikit', 5)
;

ALTER TABLE `users`
	ADD `is_dead` TINYINT(1) NULL DEFAULT '0'
;
