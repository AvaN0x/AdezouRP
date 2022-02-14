-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

CREATE TABLE IF NOT EXISTS `ava_vehicles` (
    `id` int NOT NULL AUTO_INCREMENT,
    `ownertype` tinyint NOT NULL DEFAULT 1 COMMENT '0 = player\n1 = job',
    `citizenid` int DEFAULT NULL,
    `job_name` varchar(50) DEFAULT NULL,
    `label` varchar(50) NOT NULL,
    `model` varchar(50) NOT NULL,
    `plate` varchar(12) NOT NULL,
    `parked` BOOLEAN DEFAULT false,
    `garage` varchar(50) NOT NULL DEFAULT 'garage_pillbox',
    `modsdata` longtext NOT NULL,
    `healthdata` longtext NOT NULL,
    `vehicletype` tinyint NOT NULL COMMENT '0 = car\n1 = boat\n2 = plane\n3 = helicopter',
    `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT FK_vehicles_players_citizenid FOREIGN KEY(`citizenid`) REFERENCES `ava_players`(`id`) ON DELETE SET NULL,
    CONSTRAINT FK_vehicles_jobs_job_name FOREIGN KEY(`job_name`) REFERENCES `ava_jobs`(`name`) ON DELETE SET NULL,
    CONSTRAINT CHK_vehicles_ownertypes CHECK(`ownertype` >= 0 AND `ownertype` <= 1),
    CONSTRAINT CHK_vehicles_vehicletypes CHECK(`vehicletype` >= 0 AND `vehicletype` <= 3)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- CREATE TABLE `user_parking` (
--     `citizenid` int NOT NULL,
--     `car` int(11) NOT NULL DEFAULT 2,
--     `boat` int(11) NOT NULL DEFAULT 1,
--     `plane` int(11) NOT NULL DEFAULT 0,
--     `heli` int(11) NOT NULL DEFAULT 0,

--     PRIMARY KEY (`identifier`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"Ignus","ignus","61CIR397","garage_pillbox","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"Camtar","kamacho","61CHO397","garage_pillbox","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"GRANGeR","granger","61CaO397","garage_pillbox","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"ROOOOOOOSVELT","btype3","61CdO397","garage_pillbox","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"La komoda","komoda","21CIR397","garage_pillbox","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"Volatus","volatus","11CIR397","garage_pillbox","{}", "{}",3, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"ItaliRSX","italirsx","62CIR397","garage_lspd","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"Reeeeevière","reever","69CIR397","pound_davis","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,58,"Shinobi","shinobi","69CIR397","garage_lost","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `citizenid`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (0,59,"Bati 801","bati","69CLE397","garage_lost","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `job_name`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (1,"lspd","Police buffalo","police2","63CIR397","jobgarage_lspd","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `job_name`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (1,"lspd","Police buffalo 28","police2","63CIR327","pound_davis","{}", "{}",0, 1);
-- INSERT INTO `ava_vehicles`(`ownertype`, `job_name`, `label`, `model`, `plate`, `garage`, `modsdata`, `healthdata`, `vehicletype`, `parked`) VALUES (1,"winemaker","f620","f620","83PIR327","pound_davis","{}", "{}",0, 1);