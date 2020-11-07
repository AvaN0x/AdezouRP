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
	('ems',0,'employee','Ambulancier', 20, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"chain_1":96,"glasses_1":5,"tshirt_2":0,"shoes_2":22,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"helmet_1":-1,"tshirt_1":15,"torso_2":0,"helmet_2":0,"arms":109,"bproof_1":0,"shoes_1":62,"torso_1":258,"pants_1":23,"bags_2":0,"chain_2":0}'),
	('ems',1,'doctor','Medecin', 40, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"chain_1":96,"glasses_1":5,"tshirt_2":0,"shoes_2":22,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"helmet_1":-1,"tshirt_1":15,"torso_2":0,"helmet_2":0,"arms":109,"bproof_1":0,"shoes_1":62,"torso_1":258,"pants_1":23,"bags_2":0,"chain_2":0}'),
	('ems',2,'boss','Directeur', 80, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"chain_1":96,"glasses_1":5,"tshirt_2":0,"shoes_2":22,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"helmet_1":-1,"tshirt_1":15,"torso_2":0,"helmet_2":0,"arms":109,"bproof_1":0,"shoes_1":62,"torso_1":258,"pants_1":23,"bags_2":0,"chain_2":0}')
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
