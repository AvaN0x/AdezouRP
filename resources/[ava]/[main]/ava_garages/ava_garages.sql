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
    `moddata` longtext NOT NULL,
    `vehicletype` tinyint NOT NULL COMMENT '0 = car\n1 = boat\n2 = plane\n3 = helicopter',
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
