-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

-- If a player or a job is deleted, the bill will be deleted
-- Type must be between 0 and 3
-- Amount cannot be negative or 0
-- A bill cannot be from and to the same player / job
CREATE TABLE IF NOT EXISTS `ava_bills` (
    `id` int NOT NULL AUTO_INCREMENT,
    `type` tinyint NOT NULL COMMENT '0 = player to player\n1 = player to job\n2 = job to player\n3 = job to job',
    `player_from` int DEFAULT NULL,
    `player_to` int DEFAULT NULL,
    `job_from` varchar(50) DEFAULT NULL,
    `job_to` varchar(50) DEFAULT NULL,
    `amount` int NOT NULL,
    `content` varchar(256) NOT NULL,
    `date` date DEFAULT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT FK_bills_players_player_from FOREIGN KEY(`player_from`) REFERENCES `ava_players`(`id`) ON DELETE CASCADE,
    CONSTRAINT FK_bills_players_player_to FOREIGN KEY(`player_to`) REFERENCES `ava_players`(`id`) ON DELETE CASCADE,
    CONSTRAINT FK_bills_jobs_job_from FOREIGN KEY(`job_from`) REFERENCES `ava_jobs`(`name`) ON DELETE CASCADE,
    CONSTRAINT FK_bills_jobs_job_to FOREIGN KEY(`job_to`) REFERENCES `ava_jobs`(`name`) ON DELETE CASCADE,
    CONSTRAINT CHK_bills_players_from_to CHECK(`player_to` IS NULL OR `player_to` <> `player_from`),
    CONSTRAINT CHK_bills_jobs_from_to CHECK(`job_to` IS NULL OR `job_to` <> `job_from`),
    CONSTRAINT CHK_bills_types CHECK(`type` >= 0 AND `type` <= 3),
    CONSTRAINT CHK_bills_amounts CHECK(`amount` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- On insert, set date to current time
DROP TRIGGER IF EXISTS `TR_bills_dates`;
CREATE TRIGGER TR_bills_dates BEFORE INSERT ON `ava_bills` FOR EACH ROW
    SET NEW.`date` = current_time;

