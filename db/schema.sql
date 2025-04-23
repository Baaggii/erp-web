-- ============================================================
-- ERP  schema.sql  v1.0   (MySQL 8.0  utf8mb4)
-- ============================================================

CREATE DATABASE IF NOT EXISTS erp
  CHARACTER SET = utf8mb4
  COLLATE       = utf8mb4_unicode_ci;

USE erp;

-- ---------------- CORE --------------------------------------
CREATE TABLE roles (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(30)  NOT NULL,
  description VARCHAR(100)
) ENGINE = InnoDB;

CREATE TABLE users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(50)  NOT NULL UNIQUE,
  password_hash CHAR(60)     NOT NULL,
  full_name     VARCHAR(100),
  role_id       INT,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_roles
    FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE = InnoDB;

CREATE TABLE org_units (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(80) NOT NULL,
  parent_id INT,
  CONSTRAINT fk_org_units_parent
    FOREIGN KEY (parent_id) REFERENCES org_units(id)
) ENGINE = InnoDB;

-- ---------------- LOOKUP (example) --------------------------
CREATE TABLE accounts (
  id    INT PRIMARY KEY,
  name  VARCHAR(100) NOT NULL,
  type  ENUM('ASSET','LIAB','EQUITY','REV','EXP') NOT NULL
) ENGINE = InnoDB;

CREATE TABLE items (
  code   VARCHAR(30) PRIMARY KEY,
  name   VARCHAR(120) NOT NULL,
  unit   VARCHAR(10)  NOT NULL,
  price  DECIMAL(12,2) DEFAULT 0
) ENGINE = InnoDB;

-- ---------------- FINANCE -----------------------------------
CREATE TABLE SOrlogo (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  trn_date    DATE       NOT NULL,
  amount      DECIMAL(14,2) NOT NULL,
  account_id  INT        NOT NULL,
  desc_txt    TEXT,
  created_by  INT,
  created_at  TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_orlogo_account  FOREIGN KEY (account_id) REFERENCES accounts(id),
  CONSTRAINT fk_orlogo_user     FOREIGN KEY (created_by)  REFERENCES users(id),
  INDEX idx_orlogo_date (trn_date)
) ENGINE = InnoDB;

CREATE TABLE SZardal (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  trn_date    DATE       NOT NULL,
  amount      DECIMAL(14,2) NOT NULL,
  account_id  INT        NOT NULL,
  desc_txt    TEXT,
  created_by  INT,
  created_at  TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_zardal_account  FOREIGN KEY (account_id) REFERENCES accounts(id),
  CONSTRAINT fk_zardal_user     FOREIGN KEY (created_by)  REFERENCES users(id),
  INDEX idx_zardal_date (trn_date)
) ENGINE = InnoDB;

CREATE TABLE tusuv (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  fiscal_year INT        NOT NULL,
  org_id      INT        NOT NULL,
  amount      DECIMAL(14,2),
  remarks     TEXT,
  CONSTRAINT fk_tusuv_org FOREIGN KEY (org_id) REFERENCES org_units(id),
  UNIQUE KEY uk_tusuv_year_org (fiscal_year, org_id)
) ENGINE = InnoDB;

-- ---------------- INVENTORY / ASSET -------------------------
CREATE TABLE BMBurtgel (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  item_code   VARCHAR(30)  NOT NULL,
  qty         DECIMAL(12,2) NOT NULL,
  location    VARCHAR(50),
  trn_type    ENUM('IN','OUT') NOT NULL,
  ref_no      VARCHAR(40),
  trn_date    DATE           NOT NULL,
  CONSTRAINT fk_bmb_item FOREIGN KEY (item_code) REFERENCES items(code),
  INDEX idx_bmb_date (trn_date)
) ENGINE = InnoDB;

-- ---------------- ORDERS & CONTRACTS ------------------------
CREATE TABLE mmorder (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  cust_name   VARCHAR(120),
  order_date  DATE NOT NULL,
  status      ENUM('NEW','PROCESS','DONE') DEFAULT 'NEW',
  total       DECIMAL(14,2) DEFAULT 0
) ENGINE = InnoDB;

CREATE TABLE SgereeJ (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  contract_no   VARCHAR(40) NOT NULL UNIQUE,
  counterpart   VARCHAR(120),
  start_date    DATE,
  end_date      DATE,
  amount        DECIMAL(14,2),
  status        ENUM('ACTIVE','CLOSED') DEFAULT 'ACTIVE'
) ENGINE = InnoDB;

-- ---------------- PLANNING / TASKS --------------------------
CREATE TABLE plan (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  task        VARCHAR(150) NOT NULL,
  owner_id    INT,
  target_date DATE,
  status      ENUM('TODO','DOING','DONE') DEFAULT 'TODO',
  progress    TINYINT DEFAULT 0,
  CONSTRAINT fk_plan_owner FOREIGN KEY (owner_id) REFERENCES users(id)
) ENGINE = InnoDB;

-- ---------------- DYNAMIC FORM METADATA ---------------------
CREATE TABLE form_fields (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  trx_type      VARCHAR(30)  NOT NULL,
  field_name    VARCHAR(50)  NOT NULL,
  label         VARCHAR(80),
  data_type     ENUM('string','number','date','select','textarea') NOT NULL,
  editable      TINYINT(1) DEFAULT 1,
  required      TINYINT(1) DEFAULT 0,
  lookup_table  VARCHAR(50),
  lookup_label  VARCHAR(50),
  default_value VARCHAR(120),
  UNIQUE KEY uk_form_meta (trx_type, field_name)
) ENGINE = InnoDB;

-- ---------------- VIEWS (optional example) ------------------
CREATE OR REPLACE VIEW v_sorlogo_full AS
SELECT  o.id, o.trn_date, o.amount,
        a.name AS account_name,
        u.full_name AS created_by
FROM    SOrlogo o
LEFT JOIN accounts a ON a.id = o.account_id
LEFT JOIN users    u ON u.id = o.created_by;

-- ============================================================
--  END OF schema.sql
-- ============================================================
