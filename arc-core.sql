CREATE TABLE IF NOT EXISTS `players` (
    `id` INT(10) NOT NULL AUTO_INCREMENT,
    `srv_id` INT(10) NOT NULL,
    `nbid` VARCHAR(50) NOT NULL UNIQUE,
    `license` varchar(255) NOT NULL,
    `char_data` TINYTEXT NOT NULL,
    `meta_data` TINYTEXT NOT NULL,
    `coords` TINYTEXT NOT NULL,
    PRIMARY KEY (`id`)
);