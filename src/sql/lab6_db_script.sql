-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema default_schema
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Lab6
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Lab6` ;

-- -----------------------------------------------------
-- Schema Lab6
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Lab6` DEFAULT CHARACTER SET utf8 ;
USE `Lab6` ;

-- -----------------------------------------------------
-- Table `Lab6`.`Content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`Content` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`Content` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uploader_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `category` VARCHAR(50) NULL DEFAULT NULL,
  `url` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`Queue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`Queue` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`Queue` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `reviewer_id` INT UNSIGNED NULL DEFAULT NULL,
  `status` VARCHAR(50) NULL DEFAULT NULL,
  `Content_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Content_id`),
  INDEX `fk_Queue_Content_idx` (`Content_id` ASC) VISIBLE,
  CONSTRAINT `fk_Queue_Content`
    FOREIGN KEY (`Content_id`)
    REFERENCES `Lab6`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`Label`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`Label` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`Label` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`ContentLabel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`ContentLabel` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`ContentLabel` (
  `Content_id` INT UNSIGNED NOT NULL,
  `Label_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Content_id`, `Label_id`),
  INDEX `fk_ContentLabel_Content1_idx` (`Content_id` ASC) VISIBLE,
  INDEX `fk_ContentLabel_Label1_idx` (`Label_id` ASC) VISIBLE,
  CONSTRAINT `fk_ContentLabel_Content1`
    FOREIGN KEY (`Content_id`)
    REFERENCES `Lab6`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContentLabel_Label1`
    FOREIGN KEY (`Label_id`)
    REFERENCES `Lab6`.`Label` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`Subscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`Subscription` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`Subscription` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` INT UNSIGNED NOT NULL,
  `expires` DATE NULL DEFAULT NULL,
  `Content_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Content_id`),
  INDEX `fk_Subscription_Content1_idx` (`Content_id` ASC) VISIBLE,
  CONSTRAINT `fk_Subscription_Content1`
    FOREIGN KEY (`Content_id`)
    REFERENCES `Lab6`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`Account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`Account` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`Account` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `settings` TEXT NULL DEFAULT NULL,
  `name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`AccountSubscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`AccountSubscription` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`AccountSubscription` (
  `Subscription_id` INT UNSIGNED NOT NULL,
  `Subscription_Content_id` INT UNSIGNED NOT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Subscription_id`, `Subscription_Content_id`, `Account_id`),
  INDEX `fk_AccountSubscription_Subscription1_idx` (`Subscription_id` ASC, `Subscription_Content_id` ASC) VISIBLE,
  INDEX `fk_AccountSubscription_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_AccountSubscription_Subscription1`
    FOREIGN KEY (`Subscription_id` , `Subscription_Content_id`)
    REFERENCES `Lab6`.`Subscription` (`id` , `Content_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AccountSubscription_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `Lab6`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`Group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`Group` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`Group` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `info` TEXT NULL DEFAULT NULL,
  `label` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`AccountGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`AccountGroup` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`AccountGroup` (
  `Group_id` INT UNSIGNED NOT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Group_id`, `Account_id`),
  INDEX `fk_AccountGroup_Group1_idx` (`Group_id` ASC) VISIBLE,
  INDEX `fk_AccountGroup_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_AccountGroup_Group1`
    FOREIGN KEY (`Group_id`)
    REFERENCES `Lab6`.`Group` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AccountGroup_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `Lab6`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`TaskScript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`TaskScript` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`TaskScript` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `defenition` TEXT NULL DEFAULT NULL,
  `created` DATETIME NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`Session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`Session` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`Session` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NULL DEFAULT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Account_id`),
  INDEX `fk_Session_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_Session_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `Lab6`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`SessionScriptLink`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`SessionScriptLink` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`SessionScriptLink` (
  `script_id` INT UNSIGNED NOT NULL,
  `TaskScript_id` INT UNSIGNED NOT NULL,
  `Session_id` INT UNSIGNED NOT NULL,
  `Session_Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`script_id`, `TaskScript_id`, `Session_id`, `Session_Account_id`),
  INDEX `fk_SesstionScriptLink_TaskScript1_idx` (`TaskScript_id` ASC) VISIBLE,
  INDEX `fk_SesstionScriptLink_Session1_idx` (`Session_id` ASC, `Session_Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_SesstionScriptLink_TaskScript1`
    FOREIGN KEY (`TaskScript_id`)
    REFERENCES `Lab6`.`TaskScript` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SesstionScriptLink_Session1`
    FOREIGN KEY (`Session_id` , `Session_Account_id`)
    REFERENCES `Lab6`.`Session` (`id` , `Account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`Result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`Result` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`Result` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `session` INT UNSIGNED NOT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  `score` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab6`.`SessionResultLink`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab6`.`SessionResultLink` ;

CREATE TABLE IF NOT EXISTS `Lab6`.`SessionResultLink` (
  `Session_id` INT UNSIGNED NOT NULL,
  `Session_Account_id` INT UNSIGNED NOT NULL,
  `Result_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Session_id`, `Session_Account_id`, `Result_id`),
  INDEX `fk_SessionResultLink_Session1_idx` (`Session_id` ASC, `Session_Account_id` ASC) VISIBLE,
  INDEX `fk_SessionResultLink_Result1_idx` (`Result_id` ASC) VISIBLE,
  CONSTRAINT `fk_SessionResultLink_Session1`
    FOREIGN KEY (`Session_id` , `Session_Account_id`)
    REFERENCES `Lab6`.`Session` (`id` , `Account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SessionResultLink_Result1`
    FOREIGN KEY (`Result_id`)
    REFERENCES `Lab6`.`Result` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------
-- Початкові дані для таблиць
-- -----------------------------

-- 1. Account
INSERT INTO `Account` (`id`, `settings`, `name`,     `email`) VALUES
  (1, '{"theme":"light"}',  'Alice',   'alice@example.com'),
  (2, '{"theme":"dark"}',   'Bob',     'bob@example.com'),
  (3, '{"theme":"blue"}',   'Carol',   'carol@example.com'),
  (4, '{"theme":"solar"}',  'Dave',    'dave@example.com');

-- 2. Content
-- Поле `url` використовується для зберігання тексту публікації (позначимо як `text`)
INSERT INTO `Content` (`id`, `uploader_id`, `title`,               `category`,  `url`) VALUES
  (1, 1, 'Daily Tech News',     'technology', 'Latest updates on AI, #MachineLearning and #BigData trends.'),
  (2, 2, 'Sports Weekly',       'sports',     'Highlights: Football, #Olympics, and #Fitness tips for everyone.'),
  (3, 1, 'Education Today',     'education',  'New methods in #E-learning and #EdTech transforming classrooms.'),
  (4, 3, 'Global Politics',     'news',       'Insights into #Diplomacy, #Elections, and world affairs.');

-- 3. Label
-- Теги / хештеги, які система шукає у текстах
INSERT INTO `Label` (`id`, `text`) VALUES
  (1, 'MachineLearning'),
  (2, 'BigData'),
  (3, 'Olympics'),
  (4, 'Fitness'),
  (5, 'E-learning'),
  (6, 'EdTech'),
  (7, 'Diplomacy'),
  (8, 'Elections');

-- 4. ContentLabel
-- Вказує, які хештеги знайдені у кожному тексті
INSERT INTO `ContentLabel` (`Content_id`, `Label_id`) VALUES
  (1, 1), -- MachineLearning
  (1, 2), -- BigData
  (2, 3), -- Olympics
  (2, 4), -- Fitness
  (3, 5), -- E-learning
  (3, 6), -- EdTech
  (4, 7), -- Diplomacy
  (4, 8); -- Elections

-- 5. Subscription
-- Користувачі підписані на певний контент
INSERT INTO `Subscription` (`id`, `account_id`, `expires`,    `Content_id`) VALUES
  (1, 1, '2025-12-31', 1),
  (2, 2, '2025-06-30', 2),
  (3, 1, '2025-09-15', 3),
  (4, 3, '2026-01-01', 4);

-- 6. AccountSubscription
INSERT INTO `AccountSubscription` (`Subscription_id`, `Subscription_Content_id`, `Account_id`) VALUES
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 1),
  (4, 4, 3);

-- 7. Queue
-- Статуси аналізу публікацій
INSERT INTO `Queue` (`id`, `reviewer_id`, `status`,      `Content_id`) VALUES
  (1, 2, 'pending',    1),
  (2, 3, 'approved',   2),
  (3, NULL, 'in-review', 3),
  (4, 4, 'rejected',   4);

-- 8. Group
INSERT INTO `Group` (`id`, `label`,     `info`) VALUES
  (1, 'admin',     'Адміністратори системи'),
  (2, 'user',      'Звичайні користувачі, споживачі'),
  (3, 'support',   'Служба підтримки, модератори'),
  (4, 'analyst',   'Аналітики, які займаються обробкою'),
  (5, 'guest',     'Гості, з обмеженим доступом');

-- 9. AccountGroup
INSERT INTO `AccountGroup` (`Group_id`, `Account_id`) VALUES
  (1, 1), -- Alice - admin
  (2, 2), -- Bob - user
  (3, 3), -- Carol - support
  (4, 4); -- Dave - analyst

-- 10. TaskScript
INSERT INTO `TaskScript` (`id`, `defenition`,          `created`,             `title`) VALUES
  (1, 'Analyze hashtags in text',      '2025-05-01 10:00:00', 'Hashtag Analysis'),
  (2, 'Generate content summary',      '2025-05-02 12:30:00', 'Content Summary'),
  (3, 'Check content for policy',      '2025-05-03 09:15:00', 'Policy Check'),
  (4, 'Classify content category',     '2025-05-04 14:45:00', 'Category Classification');

-- 11. Session
INSERT INTO `Session` (`id`, `start_time`,           `end_time`,            `Account_id`) VALUES
  (1, '2025-05-10 08:00:00', '2025-05-10 09:00:00',  1),
  (2, '2025-05-10 10:00:00', '2025-05-10 11:30:00',  2),
  (3, '2025-05-11 14:00:00', NULL,                   1),
  (4, '2025-05-12 16:15:00', '2025-05-12 17:00:00',  3);

-- 12. SessionScriptLink
INSERT INTO `SessionScriptLink` (`script_id`, `TaskScript_id`, `Session_id`, `Session_Account_id`) VALUES
  (1, 1, 1, 1),
  (2, 2, 2, 2),
  (3, 3, 3, 1),
  (4, 4, 4, 3);

-- 13. Result
-- Результати аналізу: кількість хештегів, ключові слова у тексті (як приклад у notes)
INSERT INTO `Result` (`id`, `session`, `notes`,                 `score`) VALUES
  (1, 1, 'Found hashtags: #MachineLearning, #BigData',        2),
  (2, 2, 'Found hashtags: #Olympics, #Fitness',               2),
  (3, 3, 'Found hashtags: #E-learning, #EdTech',              2),
  (4, 4, 'Found hashtags: #Diplomacy, #Elections',            2);

-- 14. SessionResultLink
INSERT INTO `SessionResultLink` (`Session_id`, `Session_Account_id`, `Result_id`) VALUES
  (1, 1, 1),
  (2, 2, 2),
  (3, 1, 3),
  (4, 3, 4);
