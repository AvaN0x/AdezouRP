-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

CREATE TABLE IF NOT EXISTS `ava_vehicleshop` (
    `model` VARCHAR(50) NOT NULL,
    `quantity` int NOT NULL,
    PRIMARY KEY (`model`),
    CONSTRAINT CHK_vehicleshop_quantity CHECK(`quantity` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;