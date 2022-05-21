
CREATE TABLE `lspd_mdc_user_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `text` varchar(255) NOT NULL,
  `addedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `lspd_mdc_vehicle_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicleId` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `addedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
  
ALTER TABLE `lspd_mdc_vehicle_notes`
  ADD CONSTRAINT `FK_lspd_mdc_vehicle_notes_owned_vehicles` FOREIGN KEY (`vehicleId`) REFERENCES `owned_vehicles` (`id`) ON DELETE CASCADE;

CREATE TABLE `lspd_mdc_tag_suggestion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `lspd_mdc_judgments_suggestion_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `lspd_mdc_judgments_suggestion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL,
  `length` int(10) NOT NULL,
  `fee` int(10) NOT NULL,
  `categoryId` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
  
ALTER TABLE `lspd_mdc_judgments_suggestion`
  ADD CONSTRAINT `FK_lspd_mdc_judgments_suggestion_category` FOREIGN KEY (`categoryId`) REFERENCES `lspd_mdc_judgments_suggestion_category` (`id`) ON DELETE CASCADE;

CREATE TABLE `lspd_user_judgments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `crimes` varchar(1000) NOT NULL,
  `note` varchar(1000),
  `addedBy` varchar(128) NOT NULL,
  `length` int(10),
  `fee` int(10),
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

INSERT INTO `lspd_mdc_tag_suggestion` (`type`, `name`, `description`) VALUES
('CITIZEN', 'Poszukiwany', 'Obywatel jest aktualnie poszukiwany'),
('CITIZEN', 'Niebezpieczny', 'Obywatel jest niebezpieczny'),
('CITIZEN', 'Handlarz narokytków', 'Obywatel jest handlarzem narkotyków'),
('CITIZEN', 'Handlarz bronią', 'Obywatel jest handlarzem bronią'),
('CITIZEN', 'Grupa przestępcza', 'Obywatel jest powiązany z grupą przestępczą'),
('VEHICLE', 'Poszukiwany', 'Pojazd jest aktualnie poszukiwany');

CREATE TABLE `user_properties` (
  `userId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `vehicle_properties` (
  `vehicleId` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

ALTER TABLE `vehicle_properties`
	ADD CONSTRAINT `FK_vehicle_properties_owned_vehicles` FOREIGN KEY (`vehicleId`) REFERENCES `owned_vehicles` (`id`) ON DELETE CASCADE;

ALTER TABLE lspd_mdc_judgments_suggestion_category
	ADD UNIQUE (name);
	
-- v2

ALTER TABLE lspd_mdc_judgments_suggestion ADD COLUMN showName BOOL;
UPDATE `lspd_mdc_judgments_suggestion` SET `showName` = 0;

ALTER TABLE lspd_mdc_judgments_suggestion_category ADD COLUMN color varchar(20);
UPDATE `lspd_mdc_judgments_suggestion_category` SET `color` = 'gray';

ALTER TABLE `lspd_mdc_user_notes` MODIFY addedBy varchar(255) NOT NULL;
ALTER TABLE `lspd_mdc_vehicle_notes` MODIFY addedBy varchar(255) NOT NULL;

-- indexes

ALTER TABLE `user_licenses` ADD INDEX (`owner`);
ALTER TABLE `owned_properties` ADD INDEX (`owner`);
ALTER TABLE `srp_businesses` ADD INDEX (`owner`);
ALTER TABLE `lspd_mdc_user_notes` ADD INDEX (`userId`);
ALTER TABLE `user_properties` ADD INDEX (`userId`,`name`);
ALTER TABLE `lspd_user_judgments` ADD INDEX (`userId`);

