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
    `parked` BOOLEAN DEFAULT false NOT NULL,
    `garage` varchar(50) NOT NULL DEFAULT 'garage_pillbox',
    `modsdata` longtext NOT NULL,
    `healthdata` longtext NOT NULL,
    `vehicletype` tinyint NOT NULL COMMENT '0 = car\n1 = boat\n2 = plane\n3 = helicopter',
    `insurance_left` int DEFAULT 10,
    `purchase` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT PK_vehicles_id PRIMARY KEY (`id`),
    CONSTRAINT UQ_vehicles_plate UNIQUE(`plate`),
    CONSTRAINT FK_vehicles_players_citizenid FOREIGN KEY(`citizenid`) REFERENCES `ava_players`(`id`) ON DELETE SET NULL,
    CONSTRAINT FK_vehicles_jobs_job_name FOREIGN KEY(`job_name`) REFERENCES `ava_jobs`(`name`) ON DELETE SET NULL,
    CONSTRAINT CHK_vehicles_ownertypes CHECK(`ownertype` >= 0 AND `ownertype` <= 1),
    CONSTRAINT CHK_vehicles_vehicletypes CHECK(`vehicletype` >= 0 AND `vehicletype` <= 3),
    CONSTRAINT CHK_vehicles_insurance_left CHECK(`insurance_left` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE IF NOT EXISTS `ava_vehicleskeys` (
    `citizenid` int NOT NULL,
    `vehicleid` int NOT NULL,
    `keytype` tinyint NOT NULL DEFAULT 1 COMMENT '0 = owner\n1 = double (can make duplicate)\n2 = double (cannot make duplicate)',
    `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT PK_vehicleskeys_id PRIMARY KEY (`citizenid`, `vehicleid`),
    CONSTRAINT FK_vehicleskeys_players_citizenid FOREIGN KEY(`citizenid`) REFERENCES `ava_players`(`id`) ON DELETE CASCADE,
    CONSTRAINT FK_vehicleskeys_vehicles_vehicleids FOREIGN KEY(`vehicleid`) REFERENCES `ava_vehicles`(`id`) ON DELETE CASCADE,
    CONSTRAINT CHK_vehicleskeys_keytypes CHECK(`keytype` >= 0 AND `keytype` <= 2)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- CREATE TABLE `user_parking` (
--     `citizenid` int NOT NULL,
--     `car` int(11) NOT NULL DEFAULT 2,
--     `boat` int(11) NOT NULL DEFAULT 1,
--     `plane` int(11) NOT NULL DEFAULT 0,
--     `heli` int(11) NOT NULL DEFAULT 0,

--     PRIMARY KEY (`identifier`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

