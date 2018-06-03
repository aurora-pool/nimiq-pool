CREATE DATABASE pool;

CREATE USER 'pool_payout'@'%';
CREATE USER 'pool_service'@'%';
CREATE USER 'pool_server'@'%';
CREATE USER 'pool_info'@'%';

CREATE TABLE pool.user (
  id           INTEGER     PRIMARY KEY NOT NULL AUTO_INCREMENT,
  address      VARCHAR(64) NOT NULL UNIQUE
);
CREATE INDEX idx_user_address ON pool.user (address);

CREATE TABLE pool.block (
  id           INTEGER    PRIMARY KEY NOT NULL AUTO_INCREMENT,
  hash         BINARY(32) NOT NULL UNIQUE,
  height       INTEGER    NOT NULL,
  main_chain   BOOLEAN    NOT NULL DEFAULT false
);
CREATE INDEX idx_block_hash ON pool.block (hash);
CREATE INDEX idx_block_height ON pool.block (height);

CREATE TABLE pool.share (
  id           INTEGER    PRIMARY KEY NOT NULL AUTO_INCREMENT,
  user         INTEGER    NOT NULL REFERENCES pool.user(id),
  device       INTEGER    UNSIGNED NOT NULL,
  datetime     BIGINT     NOT NULL,
  prev_block   INTEGER    NOT NULL REFERENCES pool.block(id),
  difficulty   DOUBLE     NOT NULL,
  hash         BINARY(32) NOT NULL UNIQUE
);

CREATE INDEX idx_share_prev ON pool.share (prev_block);
CREATE INDEX idx_share_hash ON pool.share (hash);

CREATE TABLE pool.payin (
  id           INTEGER    PRIMARY KEY NOT NULL AUTO_INCREMENT,
  user         INTEGER    NOT NULL REFERENCES pool.user(id),
  amount       DOUBLE     NOT NULL,
  datetime     BIGINT     NOT NULL,
  block        INTEGER    NOT NULL REFERENCES pool.block(id),
  UNIQUE(user, block)
);

CREATE TABLE pool.payout (
  id           INTEGER    PRIMARY KEY NOT NULL AUTO_INCREMENT,
  user         INTEGER       NOT NULL REFERENCES pool.user(id),
  amount       DOUBLE     NOT NULL,
  datetime     BIGINT     NOT NULL,
  transaction  BINARY(32)
);

CREATE TABLE pool.payout_request (
  id           INTEGER    PRIMARY KEY NOT NULL AUTO_INCREMENT,
  user         INTEGER    NOT NULL UNIQUE REFERENCES pool.user(id)
);

GRANT SELECT,INSERT ON pool.user TO 'pool_server'@'%';
GRANT SELECT ON pool.user TO 'pool_service'@'%';
GRANT SELECT ON pool.user TO 'pool_payout'@'%';
GRANT SELECT ON pool.user TO 'pool_info'@'%';

GRANT SELECT,INSERT ON pool.block TO 'pool_server'@'%';
GRANT SELECT,INSERT,UPDATE ON pool.block TO 'pool_service'@'%';
GRANT SELECT ON pool.block TO 'pool_payout'@'%';
GRANT SELECT ON pool.block TO 'pool_info'@'%';

GRANT SELECT,INSERT ON pool.share TO 'pool_server'@'%';
GRANT SELECT ON pool.share TO 'pool_service'@'%';
GRANT SELECT ON pool.share TO 'pool_info'@'%';

GRANT SELECT ON pool.payin TO 'pool_server'@'%';
GRANT SELECT,INSERT,DELETE ON pool.payin TO 'pool_service'@'%';
GRANT SELECT ON pool.payin TO 'pool_payout'@'%';
GRANT SELECT ON pool.payin TO 'pool_info'@'%';

GRANT SELECT ON pool.payout TO 'pool_server'@'%';
GRANT SELECT,INSERT ON pool.payout TO 'pool_service'@'%';
GRANT SELECT,INSERT ON pool.payout TO 'pool_payout'@'%';
GRANT SELECT ON pool.payout TO 'pool_info'@'%';

GRANT SELECT,INSERT,DELETE ON pool.payout_request TO 'pool_server'@'%';
GRANT SELECT,DELETE ON pool.payout_request TO 'pool_payout'@'%';
GRANT SELECT ON pool.payout_request TO 'pool_info'@'%';

-- For running an sql server locally or directly EC2 run the next 3 commands.
-- Ec2 mysql has `sql_mode` of ONLY_FULL_GROUP_BY by default which we dont want.
-- for aurora you dont need to run these.

-- GRANT SUPER ON *.* TO 'root'@'%' IDENTIFIED BY 'enterprise32';
-- FLUSH PRIVILEGES;
-- SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
