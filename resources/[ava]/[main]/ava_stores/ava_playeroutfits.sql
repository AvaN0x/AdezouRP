-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

CREATE TABLE IF NOT EXISTS `ava_playeroutfits` (
    `id` int NOT NULL AUTO_INCREMENT,
    `citizenid` int NOT NULL,
    `label` varchar(50) NOT NULL,
    `outfit` TEXT DEFAULT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT FK_playeroutfits_players_citizenid FOREIGN KEY(`citizenid`) REFERENCES `ava_players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


