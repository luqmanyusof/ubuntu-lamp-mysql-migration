-- medpcs.RPT_AESTETIC definition
CREATE TABLE `RPT_AESTETIC` (
  `Application_ID` char(8) NOT NULL COMMENT 'current application ID',
  `Clinic Name` varchar(200) DEFAULT NULL,
  `Clinic Address` varchar(200) DEFAULT NULL,
  `Town` varchar(45) CHARACTER SET utf8mb4,
  `Postcode` varchar(6) DEFAULT NULL,
  `State` varchar(45) CHARACTER SET utf8mb4,
  `Type of Services` enum('GP','SS') DEFAULT NULL COMMENT 'GP-General Practrice, SS-Specialist Services',
  `Facility` varchar(120) DEFAULT NULL COMMENT 'Clinic Facility Description (English)',
  `Quantity` int(11) DEFAULT NULL COMMENT 'Quantity of facility',
  `Size` varchar(100) DEFAULT NULL COMMENT 'Facility Size'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- medpcs.cnt_ApplicationID definition

CREATE TABLE `cnt_ApplicationID` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `running_no` int(5) unsigned zerofill NOT NULL,
  `category` enum('A','AA','LA','AM','AL','T-A','D-A','M','T-T','D-D','TT','TA','TC','D-L','LC','AC','D-C','E-A') NOT NULL,
  `description` varchar(50) NOT NULL,
  `description detail` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COMMENT='reference table last Application ID';


-- medpcs.cnt_BillNo definition

CREATE TABLE `cnt_BillNo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `running_no` varchar(5) NOT NULL,
  `year` int(11) NOT NULL,
  `category` varchar(6) NOT NULL,
  `description` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;


-- medpcs.cnt_ResitNo definition

CREATE TABLE `cnt_ResitNo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `running_no` varchar(7) NOT NULL,
  `year` int(11) NOT NULL,
  `category` varchar(6) NOT NULL,
  `description` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.cnt_approval_no definition

CREATE TABLE `cnt_approval_no` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `serial_no` int(5) unsigned zerofill NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='reference table last Application ID';


-- medpcs.lt_action definition

CREATE TABLE `lt_action` (
  `cd_action` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(50) DEFAULT NULL,
  `action_bm` varchar(50) DEFAULT NULL COMMENT 'Keterangan dalam Bahasa Melayu',
  PRIMARY KEY (`cd_action`),
  KEY `action` (`action`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_action_old definition

CREATE TABLE `lt_action_old` (
  `cd_action` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cd_action`),
  KEY `action` (`action`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_amendment definition

CREATE TABLE `lt_amendment` (
  `am_id` int(11) NOT NULL AUTO_INCREMENT,
  `am_code` int(11) DEFAULT NULL COMMENT 'Refer cnt_ApplicationID.ID',
  `am_desc_bm` varchar(100) DEFAULT NULL COMMENT 'Ammendment Description',
  `am_desc_bi` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`am_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_application_status definition

CREATE TABLE `lt_application_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `code` varchar(10) NOT NULL,
  `action` char(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `status_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_area_interest definition

CREATE TABLE `lt_area_interest` (
  `id` char(3) NOT NULL,
  `description` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `status_UNIQUE` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_area_interest_sub definition

CREATE TABLE `lt_area_interest_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `chapter` enum('1','2','3A','3B') DEFAULT NULL,
  `desc_interest` enum('I','NI','MI') NOT NULL,
  `procedures` varchar(100) DEFAULT NULL,
  `personel` varchar(50) DEFAULT NULL,
  `premises` varchar(50) DEFAULT NULL,
  `area` enum('AES') NOT NULL COMMENT 'AES-Aesthetic',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COMMENT='Clinic (Area of Interest)';


-- medpcs.lt_business_venture definition

CREATE TABLE `lt_business_venture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) NOT NULL,
  `desc_bm` varchar(60) DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_capacity definition

CREATE TABLE `lt_capacity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `description_bm` varchar(100) DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  `fee` enum('Y','N') DEFAULT NULL,
  `visible` enum('Y','N') CHARACTER SET utf8mb4 NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_category definition

CREATE TABLE `lt_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `quantity` int(3) DEFAULT '1',
  `visible` enum('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_category_capacity definition

CREATE TABLE `lt_category_capacity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_category` int(11) NOT NULL,
  `id_capacity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_category3_fk` (`id_category`),
  KEY `id_capacity3_fk` (`id_capacity`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_adminreview definition

CREATE TABLE `lt_clinic_adminreview` (
  `id` int(11) NOT NULL,
  `docreview` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_checklist_category definition

CREATE TABLE `lt_clinic_checklist_category` (
  `id_cat` int(11) NOT NULL AUTO_INCREMENT,
  `desc_cat` varchar(500) DEFAULT NULL,
  `desc_cat_eng` varchar(500) DEFAULT NULL,
  `label` varchar(3) DEFAULT NULL,
  `cat_order` int(2) NOT NULL,
  `app_type` enum('REGISTRATION','TRANSFER','AMENDMENT','DISPOSAL') NOT NULL,
  `used` enum('PMC','PDC','BOTH') NOT NULL,
  `idcreated` varchar(14) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(14) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_cat`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_checklist_detail_NEW definition

CREATE TABLE `lt_clinic_checklist_detail_NEW` (
  `id_chklist` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist` varchar(500) DEFAULT NULL,
  `desc_chklist_eng` varchar(500) NOT NULL,
  `desc_detail` text,
  `chklist_order` int(2) DEFAULT NULL,
  `sts_subchklist` enum('Y','N') DEFAULT NULL,
  `cat_chklist` int(11) DEFAULT NULL,
  `used` enum('PMC','PDC','BOTH') DEFAULT NULL,
  `idcreated` varchar(14) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` varchar(14) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_chklist`),
  KEY `fk_cat_chklist` (`cat_chklist`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_chklist definition

CREATE TABLE `lt_clinic_chklist` (
  `cklist_code` int(11) NOT NULL,
  `clinic_type` enum('PMC','PDC') DEFAULT NULL COMMENT 'PMC=Private Medical Clinic, PDC=Private Dental Clinic',
  `bv_type` int(11) DEFAULT NULL COMMENT 'refer lt_business_venture',
  `id_cat` int(11) DEFAULT NULL COMMENT 'refer lt_clinic_checklist_category',
  `arrange` int(11) DEFAULT NULL,
  PRIMARY KEY (`cklist_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_chklist_toa definition

CREATE TABLE `lt_clinic_chklist_toa` (
  `cklist_code` int(11) NOT NULL,
  `clinic_type` enum('PMC','PDC') DEFAULT NULL COMMENT 'PMC=Private Medical Clinic, PDC=Private Dental Clinic',
  `bv_type` int(11) DEFAULT NULL COMMENT 'refer lt_business_venture',
  `id_cat` int(11) DEFAULT NULL COMMENT 'refer lt_clinic_checklist_category',
  `arrange` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_facility definition

CREATE TABLE `lt_clinic_facility` (
  `cf_id` int(11) NOT NULL AUTO_INCREMENT,
  `cf_desc_eng` varchar(120) DEFAULT NULL COMMENT 'Clinic Facility Description (English)',
  `cf_desc_bm` varchar(200) DEFAULT NULL COMMENT 'Clinic Facility Description (Malay)',
  `cf_type` enum('PMC','PDC') DEFAULT NULL COMMENT 'Clinic TYpe PMC="Medical", PDC="Dental"',
  PRIMARY KEY (`cf_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_service definition

CREATE TABLE `lt_clinic_service` (
  `id_clinic_service` char(2) NOT NULL,
  `desc_bm` varchar(25) DEFAULT NULL,
  `desc_bi` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id_clinic_service`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_comphfsbn definition

CREATE TABLE `lt_comphfsbn` (
  `id_comhctb` int(11) NOT NULL AUTO_INCREMENT,
  `phfs_type` int(11) DEFAULT NULL,
  `bn_code` int(2) DEFAULT NULL,
  PRIMARY KEY (`id_comhctb`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_country definition

CREATE TABLE `lt_country` (
  `id_country` int(5) NOT NULL AUTO_INCREMENT,
  `kod_country` char(3) DEFAULT NULL,
  `desc_country` varchar(100) DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_country`),
  UNIQUE KEY `kod_country` (`kod_country`)
) ENGINE=InnoDB AUTO_INCREMENT=1005 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_day definition

CREATE TABLE `lt_day` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day_code` char(1) DEFAULT NULL,
  `day_desc_bm` char(15) DEFAULT NULL,
  `day_desc_bi` char(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_department definition

CREATE TABLE `lt_department` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `visible` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_designation_group definition

CREATE TABLE `lt_designation_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE``` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_details_prior_approval definition

CREATE TABLE `lt_details_prior_approval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') NOT NULL,
  `sub_prior_approval` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_digitalsign_user definition

CREATE TABLE `lt_digitalsign_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_nric` varchar(12) NOT NULL,
  `agencyID` varchar(45) NOT NULL,
  `userID` varchar(12) NOT NULL,
  `user_email` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `user_mobile` varchar(20) NOT NULL,
  `status_active` enum('Y','N') NOT NULL,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_update` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_district definition

CREATE TABLE `lt_district` (
  `id` char(4) NOT NULL,
  `description` varchar(25) NOT NULL,
  `code` varchar(4) NOT NULL,
  `state` char(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_employment_status definition

CREATE TABLE `lt_employment_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_facility_service definition

CREATE TABLE `lt_facility_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_fee definition

CREATE TABLE `lt_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fee_desc` decimal(10,2) NOT NULL,
  `fee_word` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`fee_desc`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_floorplan_item definition

CREATE TABLE `lt_floorplan_item` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `category_bm` varchar(50) NOT NULL,
  `category_bi` varchar(50) DEFAULT NULL,
  `idcreated` int(11) NOT NULL,
  `dtcreated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='looup table Senarai Semak Pelan Lantai';


-- medpcs.lt_fpclinic_category definition

CREATE TABLE `lt_fpclinic_category` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `id_fpitem` varchar(2) DEFAULT NULL,
  `desc_bm` varchar(100) DEFAULT NULL COMMENT 'DESC. IN BM',
  `desc_eng` varchar(100) DEFAULT NULL COMMENT 'DESC IN BI',
  `used` varchar(10) DEFAULT NULL COMMENT 'BOTH OR PDC ONLY OR PMC ONLY',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_fpclinic_detail2 definition

CREATE TABLE `lt_fpclinic_detail2` (
  `id_fpdetail` int(12) NOT NULL AUTO_INCREMENT,
  `desc_bm` text COMMENT 'DESC. IN BM',
  `desc_eng` text,
  `id_fpsubitem` int(12) DEFAULT NULL,
  `chklist_order` int(2) DEFAULT NULL,
  `num` varchar(10) DEFAULT NULL,
  `act` varchar(100) DEFAULT NULL,
  `used` varchar(10) DEFAULT NULL,
  `check_status` enum('Y','N') DEFAULT NULL COMMENT 'Semasa Semakan Dokumen (Y-Perlu disemak, N-Tidak perlu semak)',
  `sv_status` enum('Y','N') DEFAULT NULL COMMENT 'Semasa Site Visit (Y-Perlu disemak, N-Tidak perlu semak)',
  `sts_subchklist` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id_fpdetail`),
  KEY `subitem_FK` (`id_fpsubitem`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_fpclinic_detail3 definition

CREATE TABLE `lt_fpclinic_detail3` (
  `id_fpdetail2` int(12) NOT NULL AUTO_INCREMENT,
  `desc_bm` text COMMENT 'DESC. IN BM',
  `desc_eng` text COMMENT 'DESC. IN BI',
  `id_fpdetail` int(12) DEFAULT NULL,
  `chklist_order` int(2) DEFAULT NULL,
  `num` varchar(10) DEFAULT NULL,
  `act` varchar(100) DEFAULT NULL,
  `used` varchar(10) DEFAULT NULL,
  `check_status` enum('Y','N') DEFAULT NULL COMMENT 'Semasa Semakan Dokumen (Y-Perlu disemak, N-Tidak perlu semak)	',
  `sv_status` enum('Y','N') DEFAULT NULL COMMENT 'Semasa Site Visit (Y-Perlu disemak, N-Tidak perlu semak)	',
  PRIMARY KEY (`id_fpdetail2`),
  KEY `subitem_FK` (`id_fpdetail`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_gender definition

CREATE TABLE `lt_gender` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) NOT NULL,
  `code` varchar(10) NOT NULL,
  `kod_lama` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_institution definition

CREATE TABLE `lt_institution` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(300) NOT NULL,
  `shortname` varchar(20) DEFAULT NULL,
  `country` varchar(4) DEFAULT NULL COMMENT 'refer lt_country',
  `idcreated` char(16) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=878 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_jkn_address definition

CREATE TABLE `lt_jkn_address` (
  `jkn_id` int(11) NOT NULL AUTO_INCREMENT,
  `jkn_name` varchar(200) DEFAULT NULL,
  `jkn_add` varchar(200) DEFAULT NULL,
  `jkn_town` varchar(100) DEFAULT NULL,
  `jkn_district` varchar(50) DEFAULT NULL,
  `jkn_postcode` varchar(5) DEFAULT NULL,
  `jkn_state` varchar(2) DEFAULT NULL,
  `jkn_no_tel` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`jkn_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_license_chklist definition

CREATE TABLE `lt_license_chklist` (
  `cklist_code` int(11) NOT NULL AUTO_INCREMENT,
  `pfhs_type` int(11) DEFAULT NULL COMMENT 'refer lt_phfs_type',
  `bv_type` int(11) DEFAULT NULL COMMENT 'refer lt_business_venture',
  `id_cat` int(11) DEFAULT NULL,
  `id_details` int(11) DEFAULT NULL,
  `id_details2` int(11) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  PRIMARY KEY (`cklist_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1632 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_license_chklist_category definition

CREATE TABLE `lt_license_chklist_category` (
  `id_cat` int(11) NOT NULL AUTO_INCREMENT,
  `category` int(2) NOT NULL,
  `desc_cat` varchar(100) NOT NULL,
  `desc_cat_bm` text NOT NULL,
  `module` enum('LA','LC') DEFAULT NULL COMMENT 'LA-New License,LC-Renew License',
  PRIMARY KEY (`id_cat`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_license_chklist_detail definition

CREATE TABLE `lt_license_chklist_detail` (
  `id_chklist` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist` varchar(500) DEFAULT NULL,
  `cat_chklist` int(2) DEFAULT NULL,
  `sts_subchklist` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`id_chklist`),
  KEY `NewIndex1` (`cat_chklist`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_license_chklist_detail2 definition

CREATE TABLE `lt_license_chklist_detail2` (
  `id_chklist_detail` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist_detail` varchar(500) DEFAULT NULL,
  `sts_chklist` enum('Y','N') DEFAULT 'Y',
  `id_chklist` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_chklist_detail`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_local_authority definition

CREATE TABLE `lt_local_authority` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=158 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_module definition

CREATE TABLE `lt_module` (
  `cd_module` int(2) NOT NULL AUTO_INCREMENT,
  `desc_module` varchar(80) NOT NULL,
  `url_module` varchar(100) NOT NULL,
  `active_status` char(1) NOT NULL COMMENT 'Y- Yes, N- No',
  `arrange` int(2) DEFAULT NULL,
  `icon` varchar(30) DEFAULT NULL,
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_module`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COMMENT='Store systen module';


-- medpcs.lt_nationality definition

CREATE TABLE `lt_nationality` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) NOT NULL,
  `code` varchar(10) NOT NULL,
  `display` enum('Y','N') DEFAULT NULL COMMENT '(N-tidak display semasa Sign up)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_pathological_waste_disposal definition

CREATE TABLE `lt_pathological_waste_disposal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_payment definition

CREATE TABLE `lt_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_adminreview definition

CREATE TABLE `lt_phfs_adminreview` (
  `id` int(11) NOT NULL,
  `docreview` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='lookuptable bagi Nama Item yang dinilai oleh pegawai penilai';


-- medpcs.lt_phfs_chklist definition

CREATE TABLE `lt_phfs_chklist` (
  `cklist_code` int(11) NOT NULL AUTO_INCREMENT,
  `pfhs_type` int(11) DEFAULT NULL COMMENT 'refer lt_phfs_type',
  `bv_type` int(11) DEFAULT NULL COMMENT 'refer lt_business_venture',
  `id_cat` int(11) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `app_type` enum('APPROVAL','TRANSFER','AMENDMENT','DISPOSAL') CHARACTER SET utf8mb4 NOT NULL,
  PRIMARY KEY (`cklist_code`)
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_chklist_category definition

CREATE TABLE `lt_phfs_chklist_category` (
  `id_cat` int(11) NOT NULL AUTO_INCREMENT,
  `desc_cat` varchar(100) NOT NULL,
  `desc_cat_bm` text,
  `module` enum('AA','TT','D-A','AL') DEFAULT NULL COMMENT 'AA-Approval,A-Registration,L-License,R-Renew',
  PRIMARY KEY (`id_cat`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_chklist_detail definition

CREATE TABLE `lt_phfs_chklist_detail` (
  `id_chklist` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist` varchar(500) DEFAULT NULL,
  `cat_chklist` int(2) DEFAULT NULL,
  `sts_subchklist` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`id_chklist`),
  KEY `NewIndex1` (`cat_chklist`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_chklist_detail2 definition

CREATE TABLE `lt_phfs_chklist_detail2` (
  `id_chklist_detail` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist_detail` varchar(500) DEFAULT NULL,
  `sts_chklist` enum('Y','N') DEFAULT 'Y',
  `id_chklist` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_chklist_detail`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_chklist_detail3 definition

CREATE TABLE `lt_phfs_chklist_detail3` (
  `id_chklist_subdetail` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist_detail` varchar(500) DEFAULT NULL,
  `sts_chklist` enum('Y','N') DEFAULT 'Y',
  `id_chklist_detail` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_chklist_subdetail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_details_type definition

CREATE TABLE `lt_phfs_details_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `phfs_sub_type` int(11) NOT NULL,
  `beds_charge` decimal(10,2) DEFAULT NULL,
  `license_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_equipment definition

CREATE TABLE `lt_phfs_equipment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `measurement` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_fee_schedule definition

CREATE TABLE `lt_phfs_fee_schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `short_Name` varchar(50) DEFAULT NULL,
  `phfs_type` varchar(10) NOT NULL COMMENT 'refer lt_phfs_type',
  `total_beds` int(11) DEFAULT NULL COMMENT 'totak beds if phfs_type=1',
  `fee` decimal(10,2) DEFAULT NULL,
  `fee_word` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_inpatient definition

CREATE TABLE `lt_phfs_inpatient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `visible` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_level definition

CREATE TABLE `lt_phfs_level` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `level` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`level`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_nonclinical definition

CREATE TABLE `lt_phfs_nonclinical` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `visible` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_outpatient definition

CREATE TABLE `lt_phfs_outpatient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_ownership_category definition

CREATE TABLE `lt_phfs_ownership_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(55) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_ownership_type definition

CREATE TABLE `lt_phfs_ownership_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_ownership_type_others definition

CREATE TABLE `lt_phfs_ownership_type_others` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) NOT NULL,
  `code` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_patient definition

CREATE TABLE `lt_phfs_patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `visible` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_sub_type definition

CREATE TABLE `lt_phfs_sub_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `phfs_type` int(11) NOT NULL,
  `license_fee` decimal(10,2) DEFAULT NULL,
  `beds_charge` decimal(10,2) DEFAULT NULL,
  `license_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_subdetails_services definition

CREATE TABLE `lt_phfs_subdetails_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `phfs_sub_services` int(11) NOT NULL,
  `visible` enum('Y','N') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_termcondition definition

CREATE TABLE `lt_phfs_termcondition` (
  `idterm` int(11) NOT NULL AUTO_INCREMENT,
  `code_form` char(3) DEFAULT NULL,
  `termsdescription` varchar(300) NOT NULL,
  `rujukan` varchar(100) DEFAULT NULL COMMENT 'Akta atau Peraturan',
  `status` char(1) NOT NULL COMMENT 'status Active (A) Or Not Active(N)',
  `createdby` varchar(16) NOT NULL,
  `createddate` datetime NOT NULL,
  PRIMARY KEY (`idterm`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_type definition

CREATE TABLE `lt_phfs_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `ShortName` varchar(20) DEFAULT NULL,
  `descriptionbm` varchar(45) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `fee` decimal(10,2) DEFAULT NULL,
  `license_fee` decimal(10,2) DEFAULT NULL,
  `beds_charge` decimal(10,2) DEFAULT NULL,
  `license_description` varchar(255) DEFAULT NULL,
  `section` int(3) NOT NULL,
  `sector` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_position definition

CREATE TABLE `lt_position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_desc` varchar(25) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` int(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_processing_fee definition

CREATE TABLE `lt_processing_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `lower` int(11) NOT NULL,
  `upper` int(11) NOT NULL,
  `charge` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_processing_fee_license definition

CREATE TABLE `lt_processing_fee_license` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `lower` int(11) NOT NULL,
  `upper` int(11) NOT NULL,
  `charge` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_professional_body definition

CREATE TABLE `lt_professional_body` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `description` varchar(35) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_proseslvl definition

CREATE TABLE `lt_proseslvl` (
  `cd_proseslvl` int(11) NOT NULL,
  `proseslevel` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`cd_proseslvl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_qualification definition

CREATE TABLE `lt_qualification` (
  `id` int(11) NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_qualification_list definition

CREATE TABLE `lt_qualification_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `shortname` varchar(200) DEFAULT NULL,
  `institution` int(11) NOT NULL,
  `qualification` int(11) NOT NULL,
  `country` int(11) NOT NULL,
  `specialist` enum('N','Y') DEFAULT 'N',
  `speciality` varchar(10) DEFAULT NULL COMMENT 'lt_specialty',
  `qual_active` enum('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1615 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_race definition

CREATE TABLE `lt_race` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) NOT NULL,
  `code` varchar(10) NOT NULL,
  `code_lama` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_reason_transfer definition

CREATE TABLE `lt_reason_transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_recruitment_enrollees definition

CREATE TABLE `lt_recruitment_enrollees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_registering_body definition

CREATE TABLE `lt_registering_body` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_role definition

CREATE TABLE `lt_role` (
  `cd_role` int(2) NOT NULL AUTO_INCREMENT,
  `desc_role` varchar(50) NOT NULL,
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_role`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_secret_question definition

CREATE TABLE `lt_secret_question` (
  `id_secret_question` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL,
  `code` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`id_secret_question`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='lookup table for Secret Question (user registration)';


-- medpcs.lt_service definition

CREATE TABLE `lt_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `clinic_type` enum('PMC','PDC') DEFAULT NULL COMMENT 'PMC-Medical, PDC-Dental',
  `visible` enum('Y','N') CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_service_specialist definition

CREATE TABLE `lt_service_specialist` (
  `ser_id` int(11) NOT NULL AUTO_INCREMENT,
  `ser_desc` varchar(200) NOT NULL,
  `ser_type` enum('PMC','PDC') DEFAULT NULL COMMENT 'PMC - Private Medical Clinic, PDC - Private Dental Clinic',
  PRIMARY KEY (`ser_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COMMENT='Modul Registration - A.2 Services (Specialist)';


-- medpcs.lt_service_sub definition

CREATE TABLE `lt_service_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_sub_service` int(11) NOT NULL,
  `id_service` int(11) NOT NULL,
  `id_phfs_type_service` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1135 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_service_type definition

CREATE TABLE `lt_service_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL,
  `tab_type` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_services_provided definition

CREATE TABLE `lt_services_provided` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_sewerage_disposal definition

CREATE TABLE `lt_sewerage_disposal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_sign_owner definition

CREATE TABLE `lt_sign_owner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sign_ic` varchar(12) CHARACTER SET utf8mb4 NOT NULL,
  `sign_name` varchar(80) CHARACTER SET utf8mb4 NOT NULL COMMENT 'link sign image',
  `url_signature` varchar(200) DEFAULT NULL,
  `status_active` enum('Y','N') CHARACTER SET utf8mb4 DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_signature definition

CREATE TABLE `lt_signature` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `no_mmc` varchar(5) DEFAULT NULL,
  `position1` varchar(100) DEFAULT NULL,
  `position2` varchar(100) DEFAULT NULL,
  `position3` varchar(100) DEFAULT NULL,
  `position4` varchar(100) DEFAULT NULL,
  `position5` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_specialist_prac definition

CREATE TABLE `lt_specialist_prac` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_specialist_prac_reimbursement definition

CREATE TABLE `lt_specialist_prac_reimbursement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_specialty definition

CREATE TABLE `lt_specialty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_state definition

CREATE TABLE `lt_state` (
  `id` char(2) NOT NULL DEFAULT '0',
  `description` varchar(45) CHARACTER SET utf8mb4 NOT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_status definition

CREATE TABLE `lt_status` (
  `cd_status` int(11) NOT NULL AUTO_INCREMENT,
  `status_desc` varchar(60) DEFAULT NULL,
  `status_view` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`cd_status`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_sub_service definition

CREATE TABLE `lt_sub_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(500) NOT NULL,
  `code` varchar(10) NOT NULL,
  `visible` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=303 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_sub_specialty definition

CREATE TABLE `lt_sub_specialty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `id_specialty` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `visible` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`),
  KEY `id_specialty_FK` (`id_specialty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_submission_section definition

CREATE TABLE `lt_submission_section` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='Section of Submission (Borang A)';


-- medpcs.lt_submodule1 definition

CREATE TABLE `lt_submodule1` (
  `cd_submodule1` int(3) NOT NULL,
  `desc_submodule1` varchar(240) NOT NULL,
  `url_submodule1` varchar(100) NOT NULL,
  `cd_module` int(2) NOT NULL,
  `active_status` char(1) DEFAULT NULL COMMENT 'Y- Yes, N- No',
  `arrange2` int(2) DEFAULT NULL,
  `icon` varchar(30) DEFAULT NULL,
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_submodule1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_submodule1_bak definition

CREATE TABLE `lt_submodule1_bak` (
  `cd_submodule1` int(2) NOT NULL AUTO_INCREMENT,
  `desc_submodule1` varchar(80) NOT NULL,
  `url_submodule1` varchar(100) NOT NULL,
  `cd_module` int(2) NOT NULL,
  `active_status` char(1) NOT NULL COMMENT 'Y- Yes, N- No',
  `arrange2` char(2) DEFAULT NULL,
  `icon` varchar(30) DEFAULT NULL,
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_submodule1`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COMMENT='Store systen module';


-- medpcs.lt_submodule1_bak4ogo23 definition

CREATE TABLE `lt_submodule1_bak4ogo23` (
  `cd_submodule1` int(2) NOT NULL AUTO_INCREMENT,
  `desc_submodule1` varchar(80) NOT NULL,
  `url_submodule1` varchar(100) NOT NULL,
  `cd_module` int(2) NOT NULL,
  `active_status` char(1) NOT NULL COMMENT 'Y- Yes, N- No',
  `arrange2` char(2) DEFAULT NULL,
  `icon` varchar(30) DEFAULT NULL,
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_submodule1`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COMMENT='Store systen module';


-- medpcs.lt_submodule2 definition

CREATE TABLE `lt_submodule2` (
  `cd_submodule2` int(2) NOT NULL AUTO_INCREMENT,
  `desc_submodule2` varchar(80) NOT NULL,
  `url_submodule2` varchar(100) NOT NULL,
  `cd_module` int(2) DEFAULT NULL,
  `cd_submodule1` int(2) NOT NULL,
  `active_status` char(1) NOT NULL COMMENT 'Y- Yes, N- No',
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_submodule2`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COMMENT='Store systen module';


-- medpcs.lt_submodule2_bak definition

CREATE TABLE `lt_submodule2_bak` (
  `cd_submodule2` int(2) NOT NULL AUTO_INCREMENT,
  `desc_submodule2` varchar(80) NOT NULL,
  `url_submodule2` varchar(100) NOT NULL,
  `cd_module` int(2) DEFAULT NULL,
  `cd_submodule1` int(2) NOT NULL,
  `active_status` char(1) NOT NULL COMMENT 'Y- Yes, N- No',
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_submodule2`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COMMENT='Store systen module';


-- medpcs.lt_submodule3 definition

CREATE TABLE `lt_submodule3` (
  `cd_submodule2` int(2) NOT NULL AUTO_INCREMENT,
  `desc_submodule2` varchar(80) NOT NULL,
  `url_submodule2` varchar(100) NOT NULL,
  `cd_module` int(2) DEFAULT NULL,
  `cd_submodule1` int(2) NOT NULL,
  `active_status` char(1) NOT NULL COMMENT 'Y- Yes, N- No',
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_submodule2`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COMMENT='Store systen module';


-- medpcs.lt_submodule3_bak definition

CREATE TABLE `lt_submodule3_bak` (
  `cd_submodule2` int(2) NOT NULL AUTO_INCREMENT,
  `desc_submodule2` varchar(80) NOT NULL,
  `url_submodule2` varchar(100) NOT NULL,
  `cd_module` int(2) DEFAULT NULL,
  `cd_submodule1` int(2) NOT NULL,
  `active_status` char(1) NOT NULL COMMENT 'Y- Yes, N- No',
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`cd_submodule2`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COMMENT='Store systen module';


-- medpcs.lt_term definition

CREATE TABLE `lt_term` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `term_code` varchar(3) DEFAULT NULL,
  `term_description` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`term_code`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_town definition

CREATE TABLE `lt_town` (
  `id` varchar(10) NOT NULL,
  `description` varchar(45) NOT NULL,
  `state` varchar(2) NOT NULL,
  `district` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_lt_town_lt_state` (`state`),
  KEY `fk_lt_town_lt_district` (`district`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_type_of_facility definition

CREATE TABLE `lt_type_of_facility` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `visible` enum('Y','N') CHARACTER SET utf8mb4 NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_type_specialist_services definition

CREATE TABLE `lt_type_specialist_services` (
  `ts_id` int(11) NOT NULL AUTO_INCREMENT,
  `ts_desc` varchar(100) NOT NULL,
  `ts_type` enum('PMC','PDC') DEFAULT NULL,
  `idcreated` varchar(14) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` varchar(14) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`ts_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COMMENT='Specialist Services (A.2)';


-- medpcs.lt_typeofletter definition

CREATE TABLE `lt_typeofletter` (
  `cd_typeofletter` int(11) NOT NULL AUTO_INCREMENT,
  `typeofletter` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cd_typeofletter`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_user_title definition

CREATE TABLE `lt_user_title` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) NOT NULL,
  `code_lama` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_vp_freq definition

CREATE TABLE `lt_vp_freq` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `description` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_vp_resp definition

CREATE TABLE `lt_vp_resp` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_ward_discipline definition

CREATE TABLE `lt_ward_discipline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `visible` enum('Y','N') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_water_supply definition

CREATE TABLE `lt_water_supply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_year definition

CREATE TABLE `lt_year` (
  `year` year(4) NOT NULL,
  PRIMARY KEY (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='look up table year';


-- medpcs.ltg_flowstatus definition

CREATE TABLE `ltg_flowstatus` (
  `id_status` int(11) NOT NULL AUTO_INCREMENT,
  `cd_proseslvl` int(3) DEFAULT NULL COMMENT 'refer lt_proseslvl',
  `cd_action` int(2) DEFAULT NULL COMMENT 'refer lt_action',
  `cd_role` int(3) DEFAULT NULL COMMENT 'refer lt_role',
  `cd_status` int(2) DEFAULT NULL COMMENT 'refer lt_status',
  `cd_nextproseslvl` int(10) DEFAULT NULL,
  `idcreated` varchar(16) NOT NULL COMMENT 'ID Created',
  `dtcreated` datetime NOT NULL COMMENT 'Date Created',
  `idupdated` varchar(16) NOT NULL COMMENT 'ID Updated',
  `dtupdated` datetime NOT NULL COMMENT 'Date Updated',
  PRIMARY KEY (`id_status`),
  KEY `cd_proseslvl` (`cd_proseslvl`,`cd_action`,`cd_role`,`cd_status`,`cd_nextproseslvl`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=293 DEFAULT CHARSET=utf8mb4 COMMENT='LT bagi Flow Proses Permohonan';


-- medpcs.ltg_flowstatus_bak definition

CREATE TABLE `ltg_flowstatus_bak` (
  `id_status` int(11) NOT NULL AUTO_INCREMENT,
  `cd_proseslvl` int(3) DEFAULT NULL COMMENT 'refer lt_proseslvl',
  `cd_action` int(2) DEFAULT NULL COMMENT 'refer lt_action',
  `cd_role` int(3) DEFAULT NULL COMMENT 'refer lt_role',
  `cd_status` int(2) DEFAULT NULL COMMENT 'refer lt_status',
  `cd_nextproseslvl` int(10) DEFAULT NULL,
  `idcreated` varchar(16) NOT NULL COMMENT 'ID Created',
  `dtcreated` datetime NOT NULL COMMENT 'Date Created',
  `idupdated` varchar(16) NOT NULL COMMENT 'ID Updated',
  `dtupdated` datetime NOT NULL COMMENT 'Date Updated',
  PRIMARY KEY (`id_status`),
  KEY `cd_proseslvl` (`cd_proseslvl`,`cd_action`,`cd_role`,`cd_status`,`cd_nextproseslvl`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=264 DEFAULT CHARSET=utf8mb4 COMMENT='LT bagi Flow Proses Permohonan';


-- medpcs.ltg_report definition

CREATE TABLE `ltg_report` (
  `id_report` int(11) NOT NULL AUTO_INCREMENT,
  `reportname` varchar(100) NOT NULL,
  PRIMARY KEY (`id_report`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='LT bagi memaparkan Jenis Laporan';


-- medpcs.ltg_report1 definition

CREATE TABLE `ltg_report1` (
  `id_report1` int(11) NOT NULL AUTO_INCREMENT,
  `id_report` int(11) NOT NULL,
  `report1name` varchar(200) NOT NULL,
  PRIMARY KEY (`id_report1`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='LT bagi memaparkan Nama Laporan';


-- medpcs.mn_reference_fee definition

CREATE TABLE `mn_reference_fee` (
  `id` int(11) NOT NULL,
  `app_type_id` varchar(2) NOT NULL COMMENT 'cnt_ApplicationID.ID',
  `app_type` varchar(3) DEFAULT NULL COMMENT 'cnt_ApplicationID.category',
  `fee_type` varchar(2) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `kod_account` varchar(10) DEFAULT NULL,
  `kod_type` varchar(20) DEFAULT NULL COMMENT 'kod penjenisan',
  `detail` varchar(200) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `amount_perkataan` varchar(150) DEFAULT NULL,
  `date_create` date NOT NULL,
  `create_by` varchar(100) NOT NULL,
  `date_update` date DEFAULT NULL,
  `update_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.qualification_1 definition

CREATE TABLE `qualification_1` (
  `id_q` int(11) NOT NULL DEFAULT '0',
  `desc_q` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `id_ins` int(11) DEFAULT '0',
  `desc_ins` varchar(250) CHARACTER SET utf8mb4 DEFAULT NULL,
  `shortname` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.qualification_2 definition

CREATE TABLE `qualification_2` (
  `QUALIFICATION` varchar(91) DEFAULT NULL,
  `INSTITUTION` varchar(126) DEFAULT NULL,
  `RINGKASAN` varchar(28) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tandatangan definition

CREATE TABLE `tandatangan` (
  `id_t` int(1) NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) DEFAULT NULL,
  `id_j` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_t`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;


-- medpcs.tbl_fee definition

CREATE TABLE `tbl_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fee` float(10,2) DEFAULT NULL,
  `nilai` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.tbl_term definition

CREATE TABLE `tbl_term` (
  `trm_id` int(11) NOT NULL AUTO_INCREMENT,
  `trm_desc` text,
  `trm_category` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`trm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_admin definition

CREATE TABLE `tr_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` int(11) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `ic_no` varchar(12) NOT NULL COMMENT 'unique',
  `state` char(2) NOT NULL,
  `department` varchar(255) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `username` varchar(12) DEFAULT NULL COMMENT 'unique',
  `password` varchar(100) DEFAULT NULL COMMENT 'encrypt',
  `category` enum('C','U','O') DEFAULT NULL COMMENT 'C-CKAPS,U-UKAPS,O-OTHERS',
  `change_password` enum('N','Y') DEFAULT 'N',
  `status_active` enum('Y','N') DEFAULT 'Y' COMMENT 'Y-Active, N-Inactive',
  `last_login` timestamp NULL DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `uq_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=959 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_admin_role definition

CREATE TABLE `tr_admin_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(12) DEFAULT NULL COMMENT 'unique',
  `role` char(2) DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_amendment_app definition

CREATE TABLE `tr_amendment_app` (
  `amd_id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` varchar(8) NOT NULL DEFAULT '' COMMENT 'Transfer /Ammend Application ID',
  `amd_code` int(11) NOT NULL DEFAULT '0' COMMENT 'Refer to lt_ammendment (am_id)',
  `amd_change_bv` enum('Y','N') DEFAULT 'N' COMMENT 'Change Nature of business venture? Yes/No',
  `amd_change_comp` enum('Y','N') DEFAULT 'N' COMMENT 'Change company if amd_change_bv=''N''',
  `amd_status` enum('0','1','2','3','5') DEFAULT NULL COMMENT '"0"=Not Approved "1"=Approved "2"=New Application 3="For Remove" 4="History" 5="Withdraw"',
  `old_value` varchar(200) DEFAULT NULL COMMENT 'Data asal',
  `new_value` varchar(200) DEFAULT NULL COMMENT 'data baru mohon',
  `idcreated` char(16) NOT NULL,
  `dtcreated` datetime DEFAULT NULL COMMENT 'date created',
  `idupdate` char(16) DEFAULT NULL,
  `dtupdate` datetime DEFAULT NULL,
  PRIMARY KEY (`amd_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4047 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_applicant definition

CREATE TABLE `tr_applicant` (
  `id_applicant` int(11) NOT NULL AUTO_INCREMENT,
  `ic_no` varchar(12) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `id_category` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_applicant`),
  UNIQUE KEY `NewIndex1` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_audit_trail definition

CREATE TABLE `tr_audit_trail` (
  `aud_id` int(11) NOT NULL AUTO_INCREMENT,
  `aud_person` varchar(100) NOT NULL,
  `aud_application_id` varchar(10) DEFAULT NULL,
  `aud_section` varchar(100) DEFAULT NULL,
  `aud_action` varchar(20) DEFAULT NULL,
  `aud_table` varchar(100) DEFAULT NULL,
  `aud_old` text,
  `aud_query` blob,
  `aud_date` datetime NOT NULL,
  PRIMARY KEY (`aud_id`)
) ENGINE=InnoDB AUTO_INCREMENT=285926 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_authsec definition

CREATE TABLE `tr_authsec` (
  `id` varchar(255) NOT NULL,
  `auth_code` varchar(255) NOT NULL,
  `ip_add` varchar(255) NOT NULL,
  `date_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) NOT NULL DEFAULT '0',
  `attempt` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `Comp_key` (`id`,`ip_add`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_business_venture definition

CREATE TABLE `tr_business_venture` (
  `id_business_venture` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `registration_no` varchar(30) NOT NULL,
  `year_register` year(4) NOT NULL,
  `category` char(1) DEFAULT NULL COMMENT '2-Partnership, 3-Body Corporate, 4-Society',
  `address` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `town` varchar(7) NOT NULL,
  `postcode` varchar(6) NOT NULL,
  `state` char(2) NOT NULL,
  `telephone` varchar(14) DEFAULT NULL,
  `fax` varchar(14) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `phfs_regno` varchar(12) DEFAULT NULL COMMENT 'PHFS Registration or Approval Number ',
  `ownership` enum('Y','N') DEFAULT 'N' COMMENT 'Modul Approval',
  `section` enum('A4','C1') DEFAULT NULL COMMENT 'Modul Registration (Section A.4 & C.1)',
  `application_id` char(20) DEFAULT NULL,
  `bv_status` enum('0','1','2','3') DEFAULT '1' COMMENT '0=Not Approved, 1=Approved, 2=New Application 3=History',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id_business_venture`),
  UNIQUE KEY `NewIndex1` (`application_id`,`registration_no`)
) ENGINE=InnoDB AUTO_INCREMENT=18607 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_cert_holder definition

CREATE TABLE `tr_cert_holder` (
  `id_ch` int(11) NOT NULL AUTO_INCREMENT,
  `ic_no_ch` varchar(12) NOT NULL,
  `application_id_ch` char(10) NOT NULL,
  `cert_no` varchar(12) DEFAULT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_ch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_area_interest definition

CREATE TABLE `tr_clinic_area_interest` (
  `id_area` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `id_area_interest` char(3) DEFAULT NULL,
  `id_sub` int(11) DEFAULT NULL COMMENT 'FK:lt_area_interest_sub',
  `area_interest_status` enum('1','2','3','4') DEFAULT '1' COMMENT 'status permohonan pindaan',
  `application_id` char(10) DEFAULT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_area`,`idcreated`,`dtcreated`)
) ENGINE=InnoDB AUTO_INCREMENT=13482 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_category definition

CREATE TABLE `tr_clinic_category` (
  `cc_id` int(11) NOT NULL AUTO_INCREMENT,
  `cc_status` int(11) NOT NULL,
  `cc_remark` text,
  `cc_category` varchar(20) NOT NULL,
  `cc_ci_id` varchar(10) NOT NULL,
  PRIMARY KEY (`cc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=179534 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_cert definition

CREATE TABLE `tr_clinic_cert` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fi_reference1` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'Set Fee Letter - rujukan tuan',
  `fi_reference2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'Set Fee Letter - rujukan kami',
  `fi_date` date DEFAULT NULL COMMENT 'Set Fee Letter - Date',
  `fi_para3` text CHARACTER SET utf8mb4 COMMENT 'Set Fee Letter - para3',
  `fi_signature` int(11) DEFAULT NULL COMMENT 'Set Fee Letter - signature (rujuk lt_signature)',
  `cert_reg_no` varchar(20) DEFAULT NULL COMMENT 'Set Cert - cert_reg_no=a|b|c',
  `cert_app_no` varchar(25) DEFAULT NULL COMMENT 'Apnedix Number',
  `cert_approved_date` date DEFAULT NULL COMMENT 'Set Cert - DG Approval Date',
  `cert_fee` int(11) DEFAULT NULL COMMENT 'Set Cert - Fee- Rujuk lt_fee',
  `cert_serial_no` varchar(25) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'Set Cert - cert serial number',
  `cert_signature` int(11) DEFAULT NULL COMMENT 'Set Cert - cert signature (rujuk lt_signature)',
  `cl_reference1` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'set cover letter - rujukan tuan re',
  `cl_reference2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'set cover letter - rujukan kami',
  `cl_date` date DEFAULT NULL COMMENT 'set cover letter - date',
  `cl_receipt_number` varchar(19) DEFAULT NULL COMMENT 'set cover letter - receipt number',
  `cl_signature` int(11) DEFAULT NULL COMMENT 'set cover letter - signature (rujuk lt_signature)',
  `cert_signstatus` int(1) NOT NULL DEFAULT '0',
  `cl_para32` text,
  `cl_para33` text,
  `cl_para34` text,
  `app_term_duration` varchar(12) DEFAULT NULL COMMENT 'Appendix-Tempoh Term and Condition',
  `app_clinichour` text COMMENT 'Appendix- Clinic Hour',
  `catatan` text,
  `dispos_date` varchar(15) DEFAULT NULL COMMENT 'tarikh surat dispos',
  `dispos_lost` enum('Y','N') DEFAULT NULL,
  `dispos_policerpt` varchar(25) DEFAULT NULL,
  `dispos_policerpt_dt` date DEFAULT NULL,
  `application_id` char(8) CHARACTER SET utf8mb4 NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `id_created` char(12) DEFAULT NULL,
  `id_modified` char(12) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `application_id` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20180 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_facility definition

CREATE TABLE `tr_clinic_facility` (
  `cf_code` int(11) NOT NULL AUTO_INCREMENT,
  `cf_id` int(11) DEFAULT NULL COMMENT 'Refer lt_clinic_facility',
  `cf_application_id` varchar(8) DEFAULT NULL,
  `cf_quantity` int(11) DEFAULT NULL COMMENT 'Quantity of facility',
  `cf_size` varchar(100) DEFAULT NULL COMMENT 'Facility Size',
  `cf_status` enum('1','2','3','4') DEFAULT '1',
  PRIMARY KEY (`cf_code`)
) ENGINE=InnoDB AUTO_INCREMENT=61044 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_fee definition

CREATE TABLE `tr_clinic_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` varchar(10) NOT NULL,
  `payment` decimal(10,2) DEFAULT NULL,
  `mo_no` varchar(45) DEFAULT NULL,
  `receipt_no` varchar(45) DEFAULT NULL,
  `file_no` varchar(25) DEFAULT NULL,
  `our_reference` varchar(100) DEFAULT NULL,
  `their_reference` varchar(100) DEFAULT NULL,
  `letter_date` date DEFAULT NULL,
  `fee` decimal(10,2) NOT NULL,
  `fee_in_words` varchar(255) DEFAULT NULL,
  `signature` int(11) DEFAULT NULL,
  `file_no_2` varchar(25) DEFAULT '',
  `our_reference_2` varchar(255) DEFAULT '',
  `their_reference_2` varchar(255) DEFAULT '',
  `letter_date_2` date DEFAULT NULL,
  `signature_2` int(11) DEFAULT NULL,
  `services` varchar(255) DEFAULT NULL,
  `capacity` varchar(255) DEFAULT NULL,
  `term` varchar(255) DEFAULT NULL,
  `appendix_no` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `file_no_3` varchar(25) NOT NULL,
  `our_reference_3` varchar(255) DEFAULT '',
  `their_reference_3` varchar(255) DEFAULT '',
  `letter_date_3` date DEFAULT NULL,
  `para_4` enum('Y','N') DEFAULT 'Y',
  `signature_3` int(11) DEFAULT NULL,
  `file_no_4` varchar(25) DEFAULT NULL,
  `our_reference_4` varchar(25) DEFAULT NULL,
  `their_reference_4` varchar(25) DEFAULT NULL,
  `letter_date_4` date DEFAULT NULL,
  `receipt_no_4` varchar(45) DEFAULT NULL,
  `fee_4` decimal(10,2) DEFAULT NULL,
  `fee_in_words_4` varchar(255) DEFAULT NULL,
  `signature_4` char(2) DEFAULT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_financial definition

CREATE TABLE `tr_clinic_financial` (
  `fin_id` int(11) NOT NULL AUTO_INCREMENT,
  `fin_paid_local` float(14,2) DEFAULT NULL,
  `fin_paid_foreign` float(14,2) DEFAULT NULL,
  `fin_loan_local` float(14,2) DEFAULT NULL,
  `fin_loan_foreign` float(14,2) DEFAULT NULL,
  `fin_reason` text,
  `ci_application_id` varchar(10) NOT NULL,
  `idcreated` varchar(10) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(10) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`fin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41513 DEFAULT CHARSET=utf8mb4 COMMENT='E.3 FINANCIAL STATEMENT INFORMATION';


-- medpcs.tr_clinic_hour definition

CREATE TABLE `tr_clinic_hour` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` enum('0','1','2','3','4','5','6') DEFAULT NULL,
  `time_from` time NOT NULL,
  `time_to` time NOT NULL,
  `time_status` enum('1','2','3','4') DEFAULT '1',
  `operation` enum('O','R') DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tr_clinic_hour` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=259399 DEFAULT CHARSET=utf8mb4 COMMENT='A.5 Stipulated Clinic hour';


-- medpcs.tr_clinic_info definition

CREATE TABLE `tr_clinic_info` (
  `ci_id` int(11) NOT NULL AUTO_INCREMENT,
  `ci_name` varchar(200) DEFAULT NULL,
  `ci_date_established` date DEFAULT NULL,
  `ci_address` varchar(200) DEFAULT NULL,
  `ci_town` varchar(7) DEFAULT NULL,
  `ci_district` varchar(4) DEFAULT NULL,
  `ci_postcode` varchar(6) DEFAULT NULL,
  `ci_state` varchar(2) DEFAULT NULL,
  `ci_tel` varchar(14) DEFAULT NULL,
  `ci_fax` varchar(14) DEFAULT NULL,
  `ci_email` varchar(100) DEFAULT NULL,
  `ci_applicant` varchar(12) DEFAULT NULL COMMENT 'ic no applicant',
  `ci_pic` varchar(12) DEFAULT NULL COMMENT 'ic no person incharge',
  `ci_authperson` varchar(12) DEFAULT NULL COMMENT 'ic no authorized person',
  `hours` enum('Y','N') DEFAULT NULL COMMENT 'Does your clinic 24 hours?',
  `ci_week` varchar(200) DEFAULT NULL COMMENT 'if the clinic operating certain week',
  `ci_pi_id` varchar(11) DEFAULT NULL,
  `ci_regno` varchar(20) DEFAULT NULL COMMENT 'Clinic Registration Number',
  `ci_regapproved_date` date DEFAULT NULL COMMENT 'Tarikh kelulusan pendaftaran',
  `ci_fileno` varchar(50) DEFAULT NULL COMMENT 'No. Fail CKAPS',
  `transfer` int(2) DEFAULT '0' COMMENT '0-no, 1-yes',
  `ammend` int(2) DEFAULT '0' COMMENT '0-no, 1-yes',
  `dispose` int(2) DEFAULT '0' COMMENT '0-no, 1-yes',
  `ci_area_interest` enum('Y','N') DEFAULT 'N' COMMENT 'area interest services',
  `area_interest_detail` enum('AES','OSH') DEFAULT NULL COMMENT 'AES- Aesthetic, OSH-Occupational Safety and Health',
  `application_status` int(11) DEFAULT NULL COMMENT 'application status (ltg_flowstatus)',
  `ci_application_id` char(8) NOT NULL COMMENT 'current application ID',
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`ci_id`),
  UNIQUE KEY `ci_application_id` (`ci_application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49201 DEFAULT CHARSET=utf8mb4 COMMENT='Store latest Info about Clinic';


-- medpcs.tr_clinic_letter definition

CREATE TABLE `tr_clinic_letter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `meeting_code` enum('JKP','JKKP','MINI JKP') DEFAULT NULL COMMENT 'Jenis Mesyuarat',
  `meeting_no` varchar(15) DEFAULT NULL COMMENT 'bilangan mesyuarat',
  `meeting_date` datetime DEFAULT NULL COMMENT 'tarikh mesyuarat',
  `ci_id` int(11) DEFAULT NULL COMMENT 'ci_id refer to tr_clinic_info',
  `application_id` varchar(10) NOT NULL,
  `id_status` int(11) DEFAULT NULL COMMENT 'rujuk ltg_flowstatus. Status semasa evaluation',
  `term_condition` text COMMENT 'Terma dan Syarat',
  `dtcreated` datetime DEFAULT NULL,
  `dtmodified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`,`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7430 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_payment definition

CREATE TABLE `tr_clinic_payment` (
  `mn_id` int(11) NOT NULL AUTO_INCREMENT,
  `mn_type` int(11) DEFAULT NULL,
  `mn_category` int(11) DEFAULT NULL,
  `mn_issued` varchar(50) DEFAULT NULL,
  `mn_no` varchar(120) DEFAULT NULL,
  `mn_amount` double DEFAULT NULL,
  `mn_date` date DEFAULT NULL,
  `kkm_receiptno` varchar(250) DEFAULT NULL,
  `kkm_bdmono` varchar(200) DEFAULT NULL,
  `application_id` varchar(10) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`mn_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36803 DEFAULT CHARSET=utf8mb4 COMMENT='Money Order Information';


-- medpcs.tr_clinic_status_keyin definition

CREATE TABLE `tr_clinic_status_keyin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `a1` enum('Y','N') DEFAULT 'N' COMMENT 'A1. Info on Private Clinic',
  `a2` enum('Y','N') DEFAULT 'N' COMMENT 'A2. Services',
  `a31` enum('Y','N') DEFAULT 'N' COMMENT 'A31. Stipulated Clinic Hours',
  `a32` enum('Y','N') DEFAULT 'N' COMMENT 'A.3.2 Second Dr Qualification',
  `a33` enum('Y','N') DEFAULT 'N' COMMENT 'A.3.3 Second Dr Professional',
  `a34` enum('Y','N') DEFAULT 'N' COMMENT 'A.3.4 Second Dr Experience',
  `a4` enum('Y','N') DEFAULT 'N' COMMENT 'A4. Facilities and Equipment',
  `a5` enum('Y','N') DEFAULT 'Y' COMMENT 'A5. Owner/contoller - Jika Physical Linkage=yes atau Organizational linkage=yes',
  `a51` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'A.5.1 Info on Owner/Controller',
  `a52` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'A.5.2 Owner/Controller Qualification',
  `b1` enum('Y','N') DEFAULT 'N' COMMENT 'B1. Info on Applicant',
  `b2` enum('Y','N') DEFAULT 'N' COMMENT 'B2. Applicant-Qualification',
  `b3` enum('Y','N') DEFAULT 'N' COMMENT 'B3. Applicant - Professional Registration',
  `b4` enum('Y','N') DEFAULT 'N' COMMENT 'B4. Applicant - Work Experience',
  `c1` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'C1. Info on Partnership/Body Corporate/Society Jika Nature of Business Venture=Sole Propriter, tidak perlu isi',
  `c21` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'Jika Nature of Business Venture=Sole Propriter, tidak perlu isi ',
  `c22` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'Jika Nature of Business Venture=Sole Propriter, tidak perlu isi ',
  `c23` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'Jika Nature of Business Venture=Sole Propriter, tidak perlu isi ',
  `c24` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'Jika Nature of Business Venture=Sole Propriter, tidak perlu isi ',
  `d1` enum('Y','N') DEFAULT 'N' COMMENT 'D1. Info on Person Incharge (PIC)',
  `d2` enum('Y','N') DEFAULT 'N' COMMENT 'D2. PIC Qualification',
  `d3` enum('Y','N') DEFAULT 'N' COMMENT 'D3. PIC Professional Registration',
  `d4` enum('Y','N') DEFAULT 'N' COMMENT 'D4. PIC Working Experience',
  `d5` enum('Y','N') DEFAULT 'N' COMMENT 'D5. PIC Practising Address',
  `e1` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'E1. Info on Employee',
  `e12` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'E12. Category Employment',
  `e13` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'E13. Employee Qualifation',
  `e14` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'E14. Employe Professional Registration',
  `e15` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'E15. Employee Working Experience',
  `e2` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'E2. Managed Care Organisation',
  `e3` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'E3. Financial Statement',
  `f` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT 'F. Payment Info',
  `application_id` varchar(12) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30368 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_status_keyin_a definition

CREATE TABLE `tr_clinic_status_keyin_a` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `a1` enum('Y','N') DEFAULT 'N' COMMENT 'A.1 Info on Registration',
  `a2` enum('Y','N') DEFAULT 'N' COMMENT 'A.2 Term or Condition',
  `b` enum('Y','N') DEFAULT 'N' COMMENT 'B. Payment Info',
  `application_id` varchar(12) NOT NULL,
  `idcreated` varchar(12) DEFAULT NULL,
  `dtcreated` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_status_keyin_d definition

CREATE TABLE `tr_clinic_status_keyin_d` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `a2` enum('Y','N') DEFAULT 'N' COMMENT 'Maklumat disposal',
  `b` enum('Y','N') DEFAULT 'N' COMMENT 'maklumat payment',
  `application_id` varchar(12) NOT NULL,
  `idcreated` varchar(12) DEFAULT NULL,
  `dtcreated` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3205 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_status_keyin_t definition

CREATE TABLE `tr_clinic_status_keyin_t` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` varchar(12) NOT NULL COMMENT 'Application ID',
  `a32` enum('Y','N') CHARACTER SET utf8mb4 DEFAULT 'N' COMMENT 'A3.2 Reason for transfer',
  `b1` enum('Y','N') DEFAULT 'N' COMMENT 'B1 Nature of business venture',
  `b21` enum('Y','N') DEFAULT 'N' COMMENT 'B2.1 Transferee or Assignee Detail',
  `b22` enum('Y','N') DEFAULT 'N' COMMENT 'B2.2 Qualification Information',
  `b23` enum('Y','N') DEFAULT 'N' COMMENT 'B2.3 Profesional Registration',
  `b24` enum('Y','N') DEFAULT 'N' COMMENT 'B2.4 Work Experience',
  `c1` enum('Y','N') DEFAULT 'N' COMMENT 'C1 Information on BOdy Corporate',
  `c2` enum('Y','N') DEFAULT 'N' COMMENT 'C2 Member of Business Venture',
  `d1` enum('Y','N') DEFAULT 'N' COMMENT 'D1 Manage Care Organisation',
  `d2` enum('Y','N') DEFAULT 'N' COMMENT 'D2 Financial Statement Information',
  `e1` enum('Y','N') DEFAULT 'N' COMMENT 'E Maklumat pembaran',
  `idcreated` varchar(12) CHARACTER SET utf8mb4 NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) CHARACTER SET utf8mb4 DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=281 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_term definition

CREATE TABLE `tr_clinic_term` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `term_application_id` char(8) NOT NULL COMMENT 'application_id',
  `term_code` varchar(3) DEFAULT NULL COMMENT 'rujuk lt_term',
  `term_others` varchar(255) DEFAULT NULL COMMENT 'lain-lain term n condition',
  `term_justification` varchar(255) DEFAULT NULL COMMENT 'justification to remove term and condition',
  `term_status` enum('1','2','3','4') DEFAULT '1',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `id_created` char(12) DEFAULT NULL,
  `id_modified` char(12) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `newIndex2` (`term_application_id`),
  KEY `newIndex3` (`term_code`)
) ENGINE=InnoDB AUTO_INCREMENT=22606 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_type1 definition

CREATE TABLE `tr_clinic_type1` (
  `ct_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `ct_type` enum('PMC','PDC') DEFAULT NULL COMMENT 'PMC-Medical Clinic, PDC-Dental Clinic',
  `ct_mobile_clinic` enum('Y','N') DEFAULT 'N',
  `ct_type_practice` enum('S','G') DEFAULT NULL COMMENT 'S-Solo Practice, G-Group Service',
  `ct_business_venture` enum('SP','PS','BC','SC') DEFAULT NULL COMMENT 'SP-Sole Proprieter, PS-Partnership, BC-Body corporate, \nSC-Society',
  `ct_type_services` enum('GP','SS') DEFAULT NULL COMMENT 'GP-General Practrice, SS-Specialist Services',
  `ct_physical_linkage` enum('Y','N') DEFAULT NULL,
  `phfs_linkage` varchar(100) DEFAULT NULL,
  `ct_admin_linkage` enum('Y','N') DEFAULT NULL,
  `admin_linkage` varchar(100) DEFAULT NULL,
  `ct_org_linkage` enum('Y','N') DEFAULT NULL,
  `org_linkage` varchar(100) DEFAULT NULL,
  `ownership_premis` enum('OW','L','R','OT') DEFAULT NULL,
  `premis_other` varchar(100) DEFAULT NULL,
  `ct_application_id` char(8) NOT NULL,
  `ct_status` enum('0','1','2','3') DEFAULT '1' COMMENT '0=Not Approved, 1=Approved, 2=New Application 3=History',
  `idcreated` varchar(12) NOT NULL COMMENT 'id who created record',
  `dtcreated` datetime NOT NULL COMMENT 'datetime record created',
  `idupdated` varchar(12) DEFAULT NULL COMMENT 'id who modified record',
  `dtupdated` datetime DEFAULT NULL COMMENT 'datetime record modified',
  PRIMARY KEY (`ct_id`),
  KEY `ct_application_id` (`ct_application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_curr_module definition

CREATE TABLE `tr_curr_module` (
  `id_module` int(5) NOT NULL AUTO_INCREMENT,
  `cd_module` int(2) NOT NULL,
  `cd_submodule1` int(2) NOT NULL,
  `cd_submodule2` int(2) DEFAULT NULL,
  `cd_role` int(1) NOT NULL COMMENT 'refer lt_role.cd_role',
  `cur_access` enum('RW','R') NOT NULL DEFAULT 'RW' COMMENT 'RW - Read|Write   R - Read',
  `active_status` char(1) DEFAULT 'Y',
  `idcreated` char(16) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `dtupdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_module`),
  UNIQUE KEY `ck_idmodule_1` (`cd_module`,`cd_submodule1`,`cd_role`,`cd_submodule2`) USING BTREE,
  KEY `cd_role` (`cd_role`,`cd_module`)
) ENGINE=InnoDB AUTO_INCREMENT=1788 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_document definition

CREATE TABLE `tr_document` (
  `doc_id` int(11) NOT NULL DEFAULT '0',
  `doc_application_id` varchar(10) NOT NULL,
  `doc_item_id` int(4) NOT NULL COMMENT 'refer lt_item_checklist2.item_code2',
  `doc_receive_status` enum('0','1') DEFAULT '0' COMMENT '0-Pending, 1-Receive',
  `doc_receive_by` varchar(14) NOT NULL COMMENT 'UKAPS login id',
  `doc_receive_version` varchar(3) DEFAULT NULL COMMENT 'UKAPS : receipt doc',
  `doc_receive_time` datetime NOT NULL,
  `doc_check_status` enum('NR','NC','C') DEFAULT NULL COMMENT 'NR-Not Review, NC-Not Complied, C-Complied',
  `doc_check_remark` text,
  `doc_check_version` int(11) DEFAULT NULL,
  `doc_check_by` varchar(80) DEFAULT NULL,
  `doc_check_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_document_kkm definition

CREATE TABLE `tr_document_kkm` (
  `dock_id` int(11) NOT NULL AUTO_INCREMENT,
  `dock_file_no` varchar(30) DEFAULT NULL,
  `dock_category` int(11) DEFAULT NULL COMMENT 'lt_phfs_chklist_category.id_cat',
  `dock_id_chklist` int(11) DEFAULT NULL COMMENT 'lt_phfs_chklist_detail.id_chklist',
  `dock_id_chklist_detail` int(11) DEFAULT NULL COMMENT 'lt_phfs_chklist_detail.id_chklist_detail',
  `dock_id_chklist_detail2` int(11) DEFAULT NULL COMMENT 'lt_phfs_chklist_detalis3',
  `dock_receive_version` varchar(3) DEFAULT NULL,
  `dock_receive_status` int(11) DEFAULT '0',
  `dock_receive_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `dock_receive_by` varchar(80) DEFAULT NULL COMMENT 'name of person make action',
  `dock_review_version` varchar(5) DEFAULT NULL,
  `dock_review_status` int(11) DEFAULT NULL,
  `dock_review_remark` text,
  `dock_recommend_ulasanPKN` text,
  `dock_recommend_ulasanKetuaUKAPS` text,
  `dock_recommend_ulasanSokongan` text,
  `dock_recommend_ulasanPelanLantai` text,
  `dock_verify_ulasanKetuaUKAPS` text,
  `dock_decision_ulasanPKN` text,
  `dock_review_time` datetime DEFAULT NULL,
  `dock_review_by` varchar(80) DEFAULT NULL COMMENT 'name of person make action',
  `dock_level` enum('U','C') DEFAULT NULL COMMENT 'U-UKAPS, C-CKAPS',
  `dock_application_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`dock_id`)
) ENGINE=InnoDB AUTO_INCREMENT=677310 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_document_kkm_NEW definition

CREATE TABLE `tr_document_kkm_NEW` (
  `dock_id` int(11) NOT NULL AUTO_INCREMENT,
  `dock_file_no` varchar(30) DEFAULT NULL,
  `dock_category` int(11) DEFAULT NULL COMMENT 'lt_phfs_chklist_category.id_cat',
  `dock_id_chklist` int(11) DEFAULT NULL COMMENT 'lt_phfs_chklist_detail.id_chklist',
  `dock_id_chklist_detail` int(11) DEFAULT NULL COMMENT 'lt_phfs_chklist_detail.id_chklist_detail',
  `dock_receive_version` varchar(3) DEFAULT NULL,
  `dock_receive_status` int(11) DEFAULT '0',
  `dock_receive_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `dock_receive_by` varchar(80) DEFAULT NULL COMMENT 'name of person make action',
  `dock_level` enum('U','C') DEFAULT NULL COMMENT 'U-UKAPS, C-CKAPS',
  `dock_application_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`dock_id`)
) ENGINE=InnoDB AUTO_INCREMENT=678886 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_document_kkm_NEW2 definition

CREATE TABLE `tr_document_kkm_NEW2` (
  `dock_id` int(11) NOT NULL AUTO_INCREMENT,
  `dock_file_no` varchar(30) DEFAULT NULL,
  `dock_id_chklist_detail` int(11) DEFAULT NULL COMMENT 'lt_phfs_chklist_detail.id_chklist_detail',
  `dock_receive_version` varchar(3) DEFAULT NULL,
  `dock_receive_status` int(11) DEFAULT '0',
  `dock_receive_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `dock_receive_by` varchar(80) DEFAULT NULL COMMENT 'name of person make action',
  `dock_level` enum('U','C') DEFAULT NULL COMMENT 'U-UKAPS, C-CKAPS',
  `dock_application_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`dock_id`)
) ENGINE=InnoDB AUTO_INCREMENT=677104 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_employee definition

CREATE TABLE `tr_employee` (
  `emp_id` int(11) NOT NULL AUTO_INCREMENT,
  `emp_ic_no` varchar(12) NOT NULL,
  `emp_category` enum('R','O','P','L') DEFAULT NULL COMMENT 'R-Registered Medical Practitioner, O-Other Healthcare Professional, P-Non Professional',
  `emp_status` char(1) DEFAULT NULL COMMENT 'refer lt_employment_status',
  `emp_position` char(2) DEFAULT NULL COMMENT 'refer lt_position',
  `application_id` varchar(10) NOT NULL,
  `emp_status_update` enum('1','2','3','4') DEFAULT '1',
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`emp_id`),
  UNIQUE KEY `uc_employee` (`emp_ic_no`,`application_id`),
  KEY `application_id` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=158930 DEFAULT CHARSET=utf8mb4 COMMENT='E.1 Info on Employee';


-- medpcs.tr_fp_checklist definition

CREATE TABLE `tr_fp_checklist` (
  `fp_id` int(11) NOT NULL AUTO_INCREMENT,
  `fp_id_cat` int(12) DEFAULT NULL COMMENT 'lt_fpclinic_category.id',
  `fp_id_clinicdetail` int(12) DEFAULT NULL COMMENT 'lt_fpclinic_detail.id_fpsubitem',
  `fp_id_clinicdetail2` int(12) DEFAULT NULL COMMENT 'lt_fpclinic_detail2.id_fpdetail',
  `fp_id_clinicdetail3` int(12) DEFAULT NULL,
  `fp_check_status` int(11) DEFAULT NULL COMMENT 'Check Status ',
  `fp_check_remark` text,
  `fp_check_date` datetime DEFAULT NULL,
  `fp_check_by` varchar(50) NOT NULL COMMENT 'login id check person',
  `fp_sv_status` int(11) DEFAULT NULL COMMENT 'Site Visit Status',
  `fp_sv_remark` text COMMENT 'Site Visit Remarks',
  `fp_verify_date` datetime DEFAULT NULL,
  `fp_verify_by` varchar(50) DEFAULT NULL COMMENT 'login id verifier',
  `fp_application_id` varchar(10) NOT NULL COMMENT 'Clinic ID',
  PRIMARY KEY (`fp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=701583 DEFAULT CHARSET=utf8mb4 COMMENT='Store Floor Plan Checklist';


-- medpcs.tr_history_status definition

CREATE TABLE `tr_history_status` (
  `hist_id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `hist_application_id` varchar(10) DEFAULT NULL,
  `hist_status` int(11) DEFAULT NULL COMMENT 'refer lt_application_status.code',
  `hist_remark` varchar(50) DEFAULT NULL,
  `hist_by` varchar(50) NOT NULL COMMENT 'person who make action',
  `hist_role` char(2) DEFAULT NULL COMMENT 'role who make action (refer lt_role)',
  `hist_date` date DEFAULT NULL COMMENT 'Date action taken',
  PRIMARY KEY (`hist_id`),
  UNIQUE KEY `hist_id` (`hist_id`),
  UNIQUE KEY `tr_hist_unique` (`hist_application_id`,`hist_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_hod definition

CREATE TABLE `tr_hod` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hod_ic_no` varchar(12) DEFAULT NULL,
  `hod_service` int(11) DEFAULT NULL,
  `hod_application_id` char(10) DEFAULT NULL,
  `idcreated` varchar(12) DEFAULT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_mco_info definition

CREATE TABLE `tr_mco_info` (
  `mci_id` int(11) NOT NULL AUTO_INCREMENT,
  `mci_name` varchar(200) DEFAULT NULL,
  `mci_regis_no` varchar(12) DEFAULT NULL COMMENT 'registration no',
  `mci_contract` enum('C','A') DEFAULT NULL COMMENT 'C-Contract, A-Arrangement',
  `mci_date` date DEFAULT NULL,
  `mci_address` varchar(150) DEFAULT NULL,
  `mci_address2` varchar(150) DEFAULT NULL,
  `mci_address3` varchar(150) DEFAULT NULL,
  `mci_town` varchar(7) DEFAULT NULL,
  `mci_postcode` char(6) DEFAULT NULL,
  `mci_state` char(2) DEFAULT NULL,
  `mci_tel` varchar(15) DEFAULT NULL,
  `mci_fax` varchar(15) DEFAULT NULL,
  `mci_mail` varchar(150) DEFAULT NULL,
  `mci_approval_no` varchar(10) DEFAULT NULL,
  `mci_application_id` char(8) NOT NULL,
  `mci_status` int(2) NOT NULL DEFAULT '1' COMMENT '1-approved.2-new application,3-history',
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`mci_id`),
  KEY `mci_application_id` (`mci_application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1758 DEFAULT CHARSET=utf8mb4 COMMENT='E.2 Manage Care Organisation';


-- medpcs.tr_payment definition

CREATE TABLE `tr_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` varchar(10) NOT NULL,
  `no_bill` varchar(20) NOT NULL,
  `date_bill` datetime NOT NULL,
  `amount_fee` decimal(11,2) NOT NULL,
  `kod_account` varchar(20) NOT NULL,
  `description` varchar(200) NOT NULL,
  `kod_type` varchar(20) NOT NULL,
  `detail` varchar(200) NOT NULL,
  `no_receipt` varchar(25) DEFAULT NULL,
  `channel` varchar(10) DEFAULT NULL,
  `bank` varchar(20) DEFAULT NULL,
  `transaction_amount` decimal(11,2) DEFAULT NULL,
  `transaction_id` varchar(30) DEFAULT NULL,
  `transaction_date` datetime DEFAULT NULL,
  `payment_status` int(11) DEFAULT NULL,
  `date_update` date NOT NULL,
  `create_by` varchar(200) NOT NULL,
  `countBillNo` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_payment_info definition

CREATE TABLE `tr_payment_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `no_bil` varchar(20) NOT NULL,
  `amount` decimal(11,2) NOT NULL,
  `channel` varchar(8) NOT NULL,
  `bank` varchar(20) NOT NULL,
  `status_send` varchar(10) NOT NULL,
  `description` varchar(40) NOT NULL,
  `return_url` varchar(150) NOT NULL,
  `transaction_id` varchar(20) NOT NULL,
  `transaction_time` datetime NOT NULL,
  `transaction_amount` decimal(11,2) NOT NULL,
  `status_receive` varchar(10) NOT NULL,
  `pract_bank` varchar(10) NOT NULL,
  `pract_bank_id` int(11) NOT NULL,
  `unixID` varchar(100) NOT NULL,
  `invoice_no` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_person_in_charge definition

CREATE TABLE `tr_person_in_charge` (
  `pic_id` int(11) NOT NULL AUTO_INCREMENT,
  `pic_ic_no` varchar(12) NOT NULL,
  `pic_application_id` char(10) NOT NULL,
  `pic_cat` int(2) DEFAULT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`pic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23009 DEFAULT CHARSET=utf8mb4 COMMENT='Store Person in charge Information';


-- medpcs.tr_person_info definition

CREATE TABLE `tr_person_info` (
  `ic_no` varchar(12) NOT NULL COMMENT 'ic_no/pasport no',
  `title` varchar(4) NOT NULL COMMENT 'lt_user_title',
  `name` varchar(80) NOT NULL,
  `apc_no` varchar(12) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` char(2) DEFAULT NULL COMMENT '1-Male, 2-Female',
  `race` char(2) DEFAULT NULL COMMENT 'lt_race',
  `nationality` char(2) DEFAULT NULL COMMENT 'lt_nationality',
  `email` varchar(45) DEFAULT NULL,
  `telephone` varchar(14) DEFAULT NULL,
  `type_of_qualification` enum('B','S') DEFAULT NULL COMMENT 'Qualification (B-Basic, S-Specialist)',
  `declaration` varchar(3) DEFAULT NULL,
  `current_address` varchar(200) DEFAULT NULL,
  `current_town` varchar(45) DEFAULT NULL,
  `current_postcode` varchar(6) DEFAULT NULL,
  `current_state` varchar(2) DEFAULT NULL,
  `current_telephone` varchar(14) DEFAULT NULL,
  `current_fax` varchar(14) DEFAULT NULL,
  `residence_address` varchar(200) DEFAULT NULL,
  `residence_town` varchar(45) DEFAULT NULL,
  `residence_postcode` varchar(6) DEFAULT NULL,
  `residence_state` varchar(2) DEFAULT NULL,
  `residence_telephone` varchar(14) DEFAULT NULL,
  `residence_fax` varchar(14) DEFAULT NULL,
  `correspondence_address` varchar(200) DEFAULT NULL,
  `correspondence_town` varchar(45) DEFAULT NULL,
  `correspondence_postcode` varchar(6) DEFAULT NULL,
  `correspondence_state` varchar(2) DEFAULT NULL,
  `correspondence_telephone` varchar(14) DEFAULT NULL,
  `correspondence_fax` varchar(14) DEFAULT NULL,
  `healthcare_pro` enum('Y','N') DEFAULT NULL COMMENT 'Y-healthcare professional , N Non healthcare pro',
  `application_id` varchar(10) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`ic_no`,`application_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='all personal info';


-- medpcs.tr_phfs definition

CREATE TABLE `tr_phfs` (
  `id_phfs` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `name` varchar(300) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `address3` varchar(100) DEFAULT NULL,
  `town` varchar(7) DEFAULT NULL,
  `postcode` varchar(6) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `district` varchar(4) DEFAULT NULL,
  `outpatient_services` enum('Y','N') DEFAULT 'N',
  `zoning_no` varchar(14) DEFAULT NULL COMMENT 'eg : ZON10-12435-01',
  `linkage` enum('N','Y') DEFAULT 'N' COMMENT 'Y-perkhidmatan gabungan',
  `business_venture` int(11) DEFAULT NULL COMMENT 'A.2 business nature (lt_business_venture)',
  `application_status` int(11) DEFAULT NULL,
  `submission_date` date DEFAULT NULL,
  `submission_time` time DEFAULT NULL,
  `approval_no` varchar(45) DEFAULT NULL,
  `approved_date` datetime DEFAULT NULL,
  `license_no` varchar(45) DEFAULT NULL,
  `license_approved_date` datetime DEFAULT NULL,
  `ammend` int(2) DEFAULT '0' COMMENT '0-no, 1-yes',
  `transfer` int(2) DEFAULT '0' COMMENT '0-no, 1-yes',
  `extend` int(2) DEFAULT '0' COMMENT '0-no, 1-yes',
  `disposal` int(2) DEFAULT '0' COMMENT '0-no, 1-yes',
  `phone_no` varchar(14) DEFAULT NULL,
  `fax_no` varchar(14) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `website` varchar(45) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id_phfs`,`application_id`),
  UNIQUE KEY `NewIndex1` (`application_id`),
  UNIQUE KEY `NewIndex2` (`approval_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1634 DEFAULT CHARSET=utf8mb4 COMMENT='Table simpan rekod PHFS asal permohonan Applicant';


-- medpcs.tr_phfs_adminreviews definition

CREATE TABLE `tr_phfs_adminreviews` (
  `id_rev` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_kronologi` int(11) DEFAULT NULL COMMENT 'fk tr_phfs_kronologi',
  `application_id` char(8) NOT NULL COMMENT 'fk from tr_phfs_application',
  `id_admreviews` int(11) NOT NULL COMMENT 'refer to lt_phfs_adminreviews',
  `cd_role` int(2) DEFAULT NULL COMMENT 'officer role- refer to lt_role',
  `reviews` text NOT NULL COMMENT 'remarks',
  `dtreviews` datetime NOT NULL COMMENT 'reviews date',
  `idreviews` varchar(12) NOT NULL COMMENT 'reviews by',
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `id_phfs` int(11) DEFAULT '0' COMMENT 'id phfs refer tr_phfs',
  PRIMARY KEY (`id_rev`),
  KEY `application_id` (`application_id`),
  KEY `id_kronologi` (`id_kronologi`)
) ENGINE=InnoDB AUTO_INCREMENT=995 DEFAULT CHARSET=utf8mb4 COMMENT='Maklumat Ulasan Pegawai Penilai';


-- medpcs.tr_phfs_block definition

CREATE TABLE `tr_phfs_block` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `block_name` varchar(50) DEFAULT NULL,
  `floor_area` varchar(45) DEFAULT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `username` (`application_id`),
  KEY `idx_tr_phfs_equipment` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1443 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_description definition

CREATE TABLE `tr_phfs_description` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facility` int(11) NOT NULL COMMENT 'Rujuk lt_facility_service',
  `description` varchar(80) NOT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_modified` date DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_tr_phfs_description_tr_applicant` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5427 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_document definition

CREATE TABLE `tr_phfs_document` (
  `doc_id` int(11) NOT NULL AUTO_INCREMENT,
  `doc_application_id` varchar(10) NOT NULL,
  `doc_item_id` int(4) NOT NULL COMMENT 'refer lt_item_checklist2.item_code2',
  `doc_receive_status` enum('0','1') DEFAULT '0' COMMENT '0-Pending, 1-Receive',
  `doc_receive_by` varchar(14) NOT NULL COMMENT 'UKAPS login id',
  `doc_receive_version` varchar(3) DEFAULT NULL COMMENT 'UKAPS : receipt doc',
  `doc_receive_time` datetime NOT NULL,
  `doc_check_status` enum('NR','NC','C') DEFAULT NULL COMMENT 'NR-Not Review, NC-Not Complied, C-Complied',
  `doc_check_remark` text,
  `doc_check_version` int(11) DEFAULT NULL,
  `doc_check_by` varchar(80) DEFAULT NULL,
  `doc_check_time` datetime DEFAULT NULL,
  PRIMARY KEY (`doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_employee definition

CREATE TABLE `tr_phfs_employee` (
  `emp_id` int(11) NOT NULL AUTO_INCREMENT,
  `emp_ic_no` varchar(12) NOT NULL,
  `emp_category` int(11) DEFAULT NULL COMMENT 'refer lt_designation_group',
  `emp_status` char(1) DEFAULT NULL COMMENT 'refer lt_employment_status',
  `emp_designation` int(11) DEFAULT NULL COMMENT 'refer lt_designation',
  `emp_application_id` char(10) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`emp_id`),
  UNIQUE KEY `uc_employee` (`emp_ic_no`,`emp_application_id`),
  KEY `application_id` (`emp_application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='E.1 Info on Employee';


-- medpcs.tr_phfs_extend_approval definition

CREATE TABLE `tr_phfs_extend_approval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_phfs` int(11) DEFAULT NULL,
  `app_application_id` char(8) DEFAULT NULL,
  `app_start_date` date DEFAULT NULL,
  `app_end_date` date DEFAULT NULL,
  `ext_period` int(2) DEFAULT NULL,
  `ext_end_date` date DEFAULT NULL,
  `ext_application_id` char(8) DEFAULT NULL,
  `ext_reason` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_extension definition

CREATE TABLE `tr_phfs_extension` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `summary` varchar(300) DEFAULT NULL,
  `description` text NOT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `category` int(2) NOT NULL COMMENT '1 extension 2 alteration',
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `username` (`application_id`),
  KEY `idx_tr_phfs_equipment` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_extension_info definition

CREATE TABLE `tr_phfs_extension_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `Q1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `Q2` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `Q3` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `Q3_details` varchar(200) DEFAULT NULL,
  `Q4` enum('Y','N') DEFAULT 'N',
  `Q5_completion` int(1) DEFAULT NULL,
  `Q6_date_completion` datetime DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `NewIndex1` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_fee definition

CREATE TABLE `tr_phfs_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charge` decimal(10,2) DEFAULT NULL COMMENT 'Total Fee',
  `payment` decimal(10,2) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1356 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_kronologi definition

CREATE TABLE `tr_phfs_kronologi` (
  `id_kronologi` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action` int(11) NOT NULL COMMENT 'refer to ltg_flowstatus.id_status',
  `action_date` datetime NOT NULL,
  `action_by` varchar(80) NOT NULL COMMENT 'Name person who make action',
  `action_reference` varchar(12) CHARACTER SET utf8mb4 DEFAULT NULL,
  `action_reason` text,
  `application_id` char(8) DEFAULT NULL COMMENT 'fk frm tr_phfs_application',
  PRIMARY KEY (`id_kronologi`),
  KEY `id_status` (`action`),
  KEY `uap_id` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1774 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_letter definition

CREATE TABLE `tr_phfs_letter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charge` decimal(10,2) DEFAULT NULL COMMENT 'Total Fee',
  `typeofletter` char(1) DEFAULT NULL COMMENT 'refer table lt_typeofletter',
  `payment` decimal(10,2) DEFAULT NULL,
  `file_no` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'Set Receipt Letter - File No.',
  `our_reference` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'Set Receipt Letter - Our Reference',
  `their_reference` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'Set Receipt Letter - Their Reference',
  `letter_date` date DEFAULT NULL COMMENT 'Set Receipt Letter - Date',
  `telno` varchar(14) DEFAULT NULL,
  `receipt_no` varchar(25) CHARACTER SET utf8mb4 DEFAULT NULL,
  `fee_in_words` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `signature` int(11) DEFAULT NULL,
  `para_4` enum('Y','N') CHARACTER SET utf8mb4 DEFAULT 'Y',
  `services` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'Set Certificate',
  `capacity` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `term` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `approval_no` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `serial_no` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `appendix_no` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `expired_date` date DEFAULT NULL,
  `ukaps` char(2) DEFAULT NULL COMMENT 'refer lt_state.code',
  `application_id` char(8) CHARACTER SET utf8mb4 NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `our_reference` (`our_reference`),
  KEY `application_id` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_level_capacity_bup08122021 definition

CREATE TABLE `tr_phfs_level_capacity_bup08122021` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `id_phfs_capacity` int(12) DEFAULT NULL,
  `block_name` int(50) DEFAULT NULL,
  `level` int(2) DEFAULT NULL,
  `quantity` int(12) DEFAULT NULL,
  `total` int(12) DEFAULT NULL,
  `flag` int(2) DEFAULT '0' COMMENT '0=applicant, 1=admin',
  `status_assign` int(2) DEFAULT '1' COMMENT '0=not approved, 1=approved',
  `application_id` char(8) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `level_restrict` (`id_phfs_capacity`,`level`,`application_id`,`flag`,`block_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2253 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_meeting definition

CREATE TABLE `tr_phfs_meeting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `meeting_code` enum('JKP','JKKP') DEFAULT NULL COMMENT 'Jenis Mesyuarat',
  `meeting_no` varchar(15) DEFAULT NULL COMMENT 'bilangan mesyuarat',
  `meeting_date` datetime DEFAULT NULL COMMENT 'tarikh mesyuarat',
  `id_phfs` int(11) DEFAULT NULL COMMENT 'refer to tr_phfs',
  `application_id` varchar(10) NOT NULL,
  `id_status` int(11) DEFAULT NULL COMMENT 'rujuk ltg_flowstatus. Status semasa evaluation',
  `term_condition` text COMMENT 'Terma dan Syarat',
  `dtcreated` datetime DEFAULT NULL,
  `dtmodified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`,`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_payment definition

CREATE TABLE `tr_phfs_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_phfs_type` enum('A','B','C','D') DEFAULT NULL,
  `payment_type` int(11) NOT NULL,
  `ref_no` varchar(25) NOT NULL,
  `institution_name` varchar(100) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date_doc` date NOT NULL,
  `kkm_receiptno` varchar(50) DEFAULT NULL,
  `kkm_bdmono` varchar(50) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1453 DEFAULT CHARSET=utf8mb4 COMMENT='Payment Info (Submit by Applicant & Receipt by CKAPS)';


-- medpcs.tr_phfs_reason_transfer definition

CREATE TABLE `tr_phfs_reason_transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `reason_transfer` int(11) DEFAULT NULL COMMENT 'refer lt_reason_transfer',
  `other_reason` text,
  `service_disrupted` char(2) DEFAULT NULL,
  `action_taken` text,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin definition

CREATE TABLE `tr_phfs_status_keyin` (
  `id_status_keyin` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `a1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `a21` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `a22` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a23` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a231` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a232` enum('Y','N') DEFAULT 'Y' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a233` enum('Y','N') DEFAULT 'Y' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a234` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a31` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `a32` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika healthcare professional',
  `a33` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika healthcare professional',
  `a34` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `b1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `b21` enum('Y','N') DEFAULT 'Y',
  `b211` enum('Y','N') DEFAULT 'Y',
  `b212` enum('Y','N') DEFAULT 'Y',
  `b22` enum('Y','N') DEFAULT 'Y',
  `b221` enum('Y','N') DEFAULT 'Y',
  `b222` enum('Y','N') DEFAULT 'Y',
  `b23` enum('Y','N') DEFAULT 'Y',
  `b24` enum('Y','N') DEFAULT 'Y',
  `b31` enum('Y','N') DEFAULT 'Y',
  `b32` enum('Y','N') DEFAULT 'Y',
  `b331` enum('Y','N') DEFAULT 'Y',
  `b332` enum('Y','N') DEFAULT 'Y',
  `b333` enum('Y','N') DEFAULT 'Y',
  `b34` enum('Y','N') DEFAULT 'Y',
  `b35` enum('Y','N') DEFAULT 'N',
  `b351` enum('Y','N') DEFAULT 'N',
  `c1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `d1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `e1` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT 'mandatori',
  `p1` enum('Y','N') DEFAULT 'N',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_status_keyin`),
  UNIQUE KEY `NewIndex1` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1440 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin_ama definition

CREATE TABLE `tr_phfs_status_keyin_ama` (
  `id_status_keyin` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `a1` enum('Y','N') DEFAULT 'N',
  `a11` enum('Y','N') DEFAULT 'N',
  `a12` enum('Y','N') DEFAULT 'N',
  `a13` enum('Y','N') DEFAULT 'N',
  `a14` enum('Y','N') DEFAULT 'N',
  `a15` enum('Y','N') DEFAULT 'N',
  `a16` enum('Y','N') DEFAULT 'N',
  `a17` enum('Y','N') DEFAULT 'N',
  `a2` enum('Y','N') DEFAULT 'N',
  `a21a` enum('Y','N') DEFAULT 'N',
  `a21a1` enum('Y','N') DEFAULT 'N',
  `a21a2` enum('Y','N') DEFAULT 'N',
  `a21b` enum('Y','N') DEFAULT 'N',
  `a21b1` enum('Y','N') DEFAULT 'N',
  `a21b2` enum('Y','N') DEFAULT 'N',
  `a21c` enum('Y','N') DEFAULT 'N',
  `a21d` enum('Y','N') DEFAULT 'N',
  `a22a` enum('Y','N') DEFAULT 'N',
  `a22b` enum('Y','N') DEFAULT 'N',
  `a22c` enum('Y','N') DEFAULT 'N',
  `a22d` enum('Y','N') DEFAULT 'N',
  `a22e` enum('Y','N') DEFAULT 'N',
  `a22e1` enum('Y','N') DEFAULT 'N',
  `a3` enum('Y','N') DEFAULT 'N',
  `b` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`id_status_keyin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin_aml definition

CREATE TABLE `tr_phfs_status_keyin_aml` (
  `id_status_keyin` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `a1` enum('Y','N') DEFAULT 'N',
  `a11` enum('Y','N') DEFAULT 'N' COMMENT 'nama premis',
  `a12` enum('Y','N') DEFAULT 'N',
  `a13` enum('Y','N') DEFAULT 'N',
  `a14` enum('Y','N') DEFAULT 'N',
  `a15` enum('Y','N') DEFAULT 'N',
  `a16` enum('Y','N') DEFAULT 'N',
  `a17` enum('Y','N') DEFAULT 'N',
  `a2` enum('Y','N') DEFAULT 'N',
  `a21a` enum('Y','N') DEFAULT 'N',
  `a21a1` enum('Y','N') DEFAULT 'N',
  `a21a2` enum('Y','N') DEFAULT 'N',
  `a21b` enum('Y','N') DEFAULT 'N',
  `a21b1` enum('Y','N') DEFAULT 'N',
  `a21b2` enum('Y','N') DEFAULT 'N',
  `a21c` enum('Y','N') DEFAULT 'N',
  `a21d` enum('Y','N') DEFAULT 'N',
  `a22a` enum('Y','N') DEFAULT 'N',
  `a22b` enum('Y','N') DEFAULT 'N',
  `a22c` enum('Y','N') DEFAULT 'N',
  `a22d` enum('Y','N') DEFAULT 'N',
  `a22e` enum('Y','N') DEFAULT 'N',
  `a3` enum('Y','N') DEFAULT 'N',
  `b` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`id_status_keyin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin_bup08122021 definition

CREATE TABLE `tr_phfs_status_keyin_bup08122021` (
  `id_status_keyin` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `a1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `a21` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `a22` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a23` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a231` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a232` enum('Y','N') DEFAULT 'Y' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a233` enum('Y','N') DEFAULT 'Y' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a234` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `a31` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `a32` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika healthcare professional',
  `a33` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika healthcare professional',
  `a34` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `b1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `b21` enum('Y','N') DEFAULT 'Y',
  `b211` enum('Y','N') DEFAULT 'Y',
  `b212` enum('Y','N') DEFAULT 'Y',
  `b22` enum('Y','N') DEFAULT 'Y',
  `b221` enum('Y','N') DEFAULT 'Y',
  `b222` enum('Y','N') DEFAULT 'Y',
  `b23` enum('Y','N') DEFAULT 'Y',
  `b24` enum('Y','N') DEFAULT 'Y',
  `b31` enum('Y','N') DEFAULT 'Y',
  `b32` enum('Y','N') DEFAULT 'Y',
  `b331` enum('Y','N') DEFAULT 'Y',
  `b332` enum('Y','N') DEFAULT 'Y',
  `b333` enum('Y','N') DEFAULT 'Y',
  `b34` enum('Y','N') DEFAULT 'Y',
  `b35` enum('Y','N') DEFAULT 'N',
  `b351` enum('Y','N') DEFAULT 'N',
  `c1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `d1` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `e1` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT 'mandatori',
  `p1` enum('Y','N') DEFAULT 'N',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_status_keyin`),
  UNIQUE KEY `NewIndex1` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=970 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin_d definition

CREATE TABLE `tr_phfs_status_keyin_d` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `b2` enum('Y','N') DEFAULT 'N' COMMENT 'Maklumat disposal',
  `c` enum('Y','N') DEFAULT 'N' COMMENT 'maklumat payment',
  `application_id` varchar(12) NOT NULL,
  `idcreated` varchar(12) DEFAULT NULL,
  `dtcreated` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin_eoa definition

CREATE TABLE `tr_phfs_status_keyin_eoa` (
  `id_status_keyin` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `a` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `b2` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `b3` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori jika a21 partnership/body corporate/society',
  `b31` enum('Y','N') DEFAULT 'N',
  `b311` enum('Y','N') DEFAULT 'N',
  `b312` enum('Y','N') DEFAULT 'N',
  `b32` enum('Y','N') DEFAULT 'N',
  `b321` enum('Y','N') DEFAULT 'N',
  `b322` enum('Y','N') DEFAULT 'N',
  `b33` enum('Y','N') DEFAULT 'N',
  `b34` enum('Y','N') DEFAULT 'N',
  `b4` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `b5` enum('Y','N') DEFAULT 'N',
  `b51` enum('Y','N') DEFAULT 'N',
  `b52` enum('Y','N') DEFAULT 'N',
  `b521` enum('Y','N') DEFAULT 'N',
  `b522` enum('Y','N') DEFAULT 'N',
  `b6` enum('Y','N') DEFAULT 'N',
  `c` enum('Y','N') DEFAULT 'N' COMMENT 'mandatori',
  `d` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT 'mandatori',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_status_keyin`),
  UNIQUE KEY `NewIndex1` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin_l definition

CREATE TABLE `tr_phfs_status_keyin_l` (
  `id_status_keyin` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `a1` enum('Y','N') DEFAULT 'N',
  `a2` enum('Y','N') DEFAULT 'N',
  `a3` enum('Y','N') DEFAULT 'N',
  `a4` enum('Y','N') DEFAULT 'Y',
  `a41` enum('Y','N') DEFAULT 'N',
  `a411` enum('Y','N') DEFAULT 'N',
  `a412` enum('Y','N') DEFAULT 'N',
  `a42` enum('Y','N') DEFAULT 'N',
  `a421` enum('Y','N') DEFAULT 'N',
  `a422` enum('Y','N') DEFAULT 'N',
  `a43` enum('Y','N') DEFAULT 'N',
  `a44` enum('Y','N') DEFAULT 'N',
  `a5` enum('Y','N') DEFAULT 'Y',
  `a51` enum('Y','N') DEFAULT 'N',
  `a52` enum('Y','N') DEFAULT 'N',
  `a53` enum('Y','N') DEFAULT 'Y',
  `b1` enum('Y','N') DEFAULT 'Y',
  `b11` enum('Y','N') DEFAULT 'N',
  `b12` enum('Y','N') DEFAULT 'N',
  `b13` enum('Y','N') DEFAULT 'N',
  `b131` enum('Y','N') DEFAULT 'N',
  `b132` enum('Y','N') DEFAULT 'N',
  `b133` enum('Y','N') DEFAULT 'N',
  `b134` enum('Y','N') DEFAULT 'N',
  `b2` enum('Y','N') DEFAULT 'N',
  `b21` enum('Y','N') DEFAULT 'N',
  `b22` enum('Y','N') DEFAULT 'N',
  `b23` enum('Y','N') DEFAULT 'N',
  `b24` enum('Y','N') DEFAULT 'N',
  `b25` enum('Y','N') DEFAULT 'N',
  `c1` enum('Y','N') DEFAULT 'N',
  `c2` enum('Y','N') DEFAULT 'N',
  `c3` enum('Y','N') DEFAULT 'N',
  `c4` enum('Y','N') DEFAULT 'N',
  `c5` enum('Y','N') DEFAULT 'N',
  `c6` enum('Y','N') DEFAULT 'Y',
  `d1` enum('Y','N') DEFAULT 'N',
  `d2` enum('Y','N') DEFAULT 'N',
  `d3` enum('Y','N') DEFAULT 'N',
  `d4` enum('Y','N') DEFAULT 'N',
  `d5` enum('Y','N') DEFAULT 'N',
  `d6` enum('Y','N') DEFAULT 'Y',
  `d7` enum('Y','N') DEFAULT 'N',
  `e1` enum('Y','N') DEFAULT 'N',
  `e2` enum('Y','N') DEFAULT 'N',
  `e3` enum('Y','N') DEFAULT 'N',
  `e4` enum('Y','N') DEFAULT 'N',
  `e5` enum('Y','N') DEFAULT 'N',
  `f1` enum('Y','N') DEFAULT 'N',
  `f11` enum('Y','N') DEFAULT 'N',
  `f12` enum('Y','N') DEFAULT 'N',
  `f13` enum('Y','N') DEFAULT 'N',
  `f14` enum('Y','N') DEFAULT 'N',
  `f15` enum('Y','N') DEFAULT 'N',
  `f2` enum('Y','N') DEFAULT 'N',
  `f3` enum('Y','N') DEFAULT 'N',
  `p1` enum('Y','N') DEFAULT 'N',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_status_keyin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin_toa definition

CREATE TABLE `tr_phfs_status_keyin_toa` (
  `id_status_keyin` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `a1` enum('Y','N') DEFAULT 'N',
  `a2` enum('Y','N') DEFAULT 'N',
  `a3` enum('Y','N') DEFAULT 'N',
  `a31` enum('Y','N') DEFAULT 'N',
  `a32` enum('Y','N') DEFAULT 'N',
  `b1` enum('Y','N') DEFAULT 'N',
  `b2` enum('Y','N') DEFAULT 'N',
  `b21` enum('Y','N') DEFAULT 'N',
  `b22` enum('Y','N') DEFAULT 'N',
  `b23` enum('Y','N') DEFAULT 'N',
  `b24` enum('Y','N') DEFAULT 'N',
  `b25` enum('Y','N') DEFAULT 'N',
  `c1` enum('Y','N') DEFAULT 'N',
  `c11` enum('Y','N') DEFAULT 'N',
  `c2` enum('Y','N') DEFAULT 'N',
  `c21` enum('Y','N') DEFAULT 'N',
  `c22` enum('Y','N') DEFAULT 'N',
  `c23` enum('Y','N') DEFAULT 'N',
  `c24` enum('Y','N') DEFAULT 'N',
  `d` enum('Y','N') DEFAULT 'N',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_status_keyin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_status_keyin_tol definition

CREATE TABLE `tr_phfs_status_keyin_tol` (
  `id_status_keyin` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `a1` enum('Y','N') DEFAULT 'N',
  `a2` enum('Y','N') DEFAULT 'N',
  `a3` enum('Y','N') DEFAULT 'N',
  `a31` enum('Y','N') DEFAULT 'N',
  `a32` enum('Y','N') DEFAULT 'N',
  `b1` enum('Y','N') DEFAULT 'N',
  `b2` enum('Y','N') DEFAULT 'N',
  `b21` enum('Y','N') DEFAULT 'N',
  `b22` enum('Y','N') DEFAULT 'N',
  `b23` enum('Y','N') DEFAULT 'N',
  `b24` enum('Y','N') DEFAULT 'N',
  `b25` enum('Y','N') DEFAULT 'N',
  `c1` enum('Y','N') DEFAULT 'N',
  `c11` enum('Y','N') DEFAULT 'N',
  `c2` enum('Y','N') DEFAULT 'N',
  `c21` enum('Y','N') DEFAULT 'N',
  `c22` enum('Y','N') DEFAULT 'N',
  `c23` enum('Y','N') DEFAULT 'N',
  `c24` enum('Y','N') DEFAULT 'N',
  `d` enum('Y','N') DEFAULT 'N',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_status_keyin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_termcondition definition

CREATE TABLE `tr_phfs_termcondition` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_kronologi` int(11) unsigned NOT NULL COMMENT 'fk frm tr_phfs_kronologi',
  `application_id` char(8) DEFAULT NULL COMMENT 'fk frm tr_phfs_application',
  `term` int(11) NOT NULL COMMENT 'refer to lt_phfs_termcondition',
  `term_status` int(2) DEFAULT '1',
  `justification` text,
  `action_date` datetime NOT NULL,
  `actionby` varchar(12) DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_kronologi` (`id_kronologi`,`application_id`,`term`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_transferee definition

CREATE TABLE `tr_phfs_transferee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `business_venture` int(2) NOT NULL,
  `ic_no_transferee` varchar(12) DEFAULT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_transferor definition

CREATE TABLE `tr_phfs_transferor` (
  `id_t` int(11) NOT NULL AUTO_INCREMENT,
  `ic_no_t` varchar(12) NOT NULL,
  `application_id_t` char(10) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_t`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_physical definition

CREATE TABLE `tr_physical` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `regno` varchar(20) DEFAULT NULL COMMENT 'Clinic Registration Number',
  `owner_controller` enum('I','O','N') DEFAULT NULL COMMENT 'I-Individual, O-Organisation, N-Not Relevant',
  `ic_regisno` varchar(12) DEFAULT NULL COMMENT 'jika I-Ic No, Jika O-Regis No',
  `application_id` varchar(10) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1787 DEFAULT CHARSET=utf8mb4 COMMENT='store info A.4';


-- medpcs.tr_pract_add definition

CREATE TABLE `tr_pract_add` (
  `id_practice` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `ic_no` varchar(12) DEFAULT NULL,
  `name_practice` varchar(150) DEFAULT NULL COMMENT 'name of any facility',
  `address1` varchar(150) DEFAULT NULL,
  `address2` varchar(150) DEFAULT NULL,
  `address3` varchar(150) DEFAULT NULL,
  `town` char(8) DEFAULT NULL,
  `district` char(8) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `pract_add_status` int(11) NOT NULL DEFAULT '1',
  `application_id` char(8) DEFAULT NULL,
  `icreated` varchar(12) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_practice`)
) ENGINE=InnoDB AUTO_INCREMENT=37345 DEFAULT CHARSET=utf8mb4 COMMENT='Practising Address ';


-- medpcs.tr_reference definition

CREATE TABLE `tr_reference` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` int(11) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `ic_no` varchar(12) NOT NULL COMMENT 'ic_no/pasport no',
  `apc_no` char(10) DEFAULT NULL,
  `telephone` varchar(14) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `race` int(11) DEFAULT NULL,
  `nationality` int(11) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `current_address` varchar(200) DEFAULT NULL,
  `current_town` varchar(7) DEFAULT NULL,
  `current_postcode` varchar(6) DEFAULT NULL,
  `current_state` char(2) DEFAULT NULL,
  `current_district` char(4) DEFAULT NULL,
  `current_telephone` varchar(14) DEFAULT NULL,
  `current_fax` varchar(14) DEFAULT NULL,
  `residence_address` varchar(200) DEFAULT NULL,
  `residence_town` char(7) DEFAULT NULL,
  `residence_postcode` varchar(6) DEFAULT NULL,
  `residence_state` char(2) DEFAULT NULL,
  `residence_district` char(4) DEFAULT NULL,
  `residence_telephone` varchar(14) DEFAULT NULL,
  `residence_fax` varchar(14) DEFAULT NULL,
  `correspondence_address` varchar(200) DEFAULT NULL,
  `correspondence_town` varchar(45) DEFAULT NULL,
  `correspondence_postcode` varchar(6) DEFAULT NULL,
  `correspondence_state` char(2) DEFAULT NULL,
  `correspondence_district` char(7) DEFAULT NULL,
  `correspondence_telephone` varchar(14) DEFAULT NULL,
  `correspondence_fax` varchar(14) DEFAULT NULL,
  `healthcare_pro` enum('Y','N') DEFAULT NULL COMMENT 'Y-Healthcare Professional, N-Non Healthcare Professional',
  `id_created` varchar(10) DEFAULT NULL COMMENT 'Application ID user created Record',
  `date_created` datetime DEFAULT NULL,
  `time_created` time DEFAULT NULL,
  `id_modified` varchar(10) DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL COMMENT 'Application ID User Modified Record',
  `time_modified` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ic_no_UNIQUE` (`ic_no`)
) ENGINE=InnoDB AUTO_INCREMENT=143478 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_reference_business_venture definition

CREATE TABLE `tr_reference_business_venture` (
  `id_rbv` int(11) NOT NULL AUTO_INCREMENT,
  `registration_no` varchar(30) DEFAULT NULL,
  `name_rbv` varchar(300) NOT NULL,
  `year_register` year(4) DEFAULT NULL,
  `category` char(1) DEFAULT NULL COMMENT '2-Body corporate, 3-Partnership, 4-Society',
  `address` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `town` varchar(7) DEFAULT NULL,
  `postcode` varchar(6) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `telephone` varchar(14) DEFAULT NULL,
  `fax` varchar(14) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `id_created` varchar(12) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `id_mofified` varchar(12) DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  UNIQUE KEY `id_UNIQUE` (`id_rbv`),
  UNIQUE KEY `NewIndex1` (`registration_no`)
) ENGINE=InnoDB AUTO_INCREMENT=11328 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_reference_copy definition

CREATE TABLE `tr_reference_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` int(11) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `ic_no` varchar(12) NOT NULL COMMENT 'ic_no/pasport no',
  `apc_no` char(10) DEFAULT NULL,
  `telephone` varchar(14) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `race` int(11) DEFAULT NULL,
  `nationality` int(11) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `current_address` varchar(200) DEFAULT NULL,
  `current_town` varchar(7) DEFAULT NULL,
  `current_postcode` varchar(6) DEFAULT NULL,
  `current_state` char(2) DEFAULT NULL,
  `current_district` char(4) DEFAULT NULL,
  `current_telephone` varchar(14) DEFAULT NULL,
  `current_fax` varchar(14) DEFAULT NULL,
  `residence_address` varchar(200) DEFAULT NULL,
  `residence_town` char(7) DEFAULT NULL,
  `residence_postcode` varchar(6) DEFAULT NULL,
  `residence_state` char(2) DEFAULT NULL,
  `residence_district` char(4) DEFAULT NULL,
  `residence_telephone` varchar(14) DEFAULT NULL,
  `residence_fax` varchar(14) DEFAULT NULL,
  `correspondence_address` varchar(200) DEFAULT NULL,
  `correspondence_town` varchar(45) DEFAULT NULL,
  `correspondence_postcode` varchar(6) DEFAULT NULL,
  `correspondence_state` char(2) DEFAULT NULL,
  `correspondence_district` char(7) DEFAULT NULL,
  `correspondence_telephone` varchar(14) DEFAULT NULL,
  `correspondence_fax` varchar(14) DEFAULT NULL,
  `healthcare_pro` enum('Y','N') DEFAULT NULL COMMENT 'Y-Healthcare Professional, N-Non Healthcare Professional',
  `id_created` varchar(10) DEFAULT NULL COMMENT 'Application ID user created Record',
  `date_created` datetime DEFAULT NULL,
  `time_created` time DEFAULT NULL,
  `id_modified` varchar(10) DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL COMMENT 'Application ID User Modified Record',
  `time_modified` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ic_no_UNIQUE` (`ic_no`)
) ENGINE=InnoDB AUTO_INCREMENT=142748 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_reference_mco definition

CREATE TABLE `tr_reference_mco` (
  `mng_id` int(11) NOT NULL AUTO_INCREMENT,
  `mng_name` varchar(77) DEFAULT NULL,
  `mng_address` varchar(138) DEFAULT NULL,
  `mng_address2` varchar(150) DEFAULT NULL,
  `mng_address3` varchar(150) DEFAULT NULL,
  `mng_town` varchar(7) DEFAULT NULL,
  `mng_postcode` varchar(12) DEFAULT NULL,
  `mng_state` char(2) DEFAULT NULL,
  `mng_tel` varchar(14) DEFAULT NULL,
  `mng_fax` varchar(14) DEFAULT NULL,
  `mng_email` varchar(90) DEFAULT NULL,
  `mng_regis_no` varchar(12) DEFAULT NULL,
  `mng_date` datetime DEFAULT NULL,
  `mng_contract` varchar(31) DEFAULT NULL,
  `mng_approval_no` varchar(15) DEFAULT NULL,
  `mng_application_id` varchar(9) DEFAULT NULL,
  `idcreated` varchar(12) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`mng_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1199 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_reference_pract_add definition

CREATE TABLE `tr_reference_pract_add` (
  `id_practice` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `ic_no` varchar(12) DEFAULT NULL,
  `name_practice` varchar(150) DEFAULT NULL COMMENT 'name of any facility',
  `address1` varchar(150) DEFAULT NULL,
  `address2` varchar(150) DEFAULT NULL,
  `address3` varchar(150) DEFAULT NULL,
  `town` char(8) DEFAULT NULL,
  `district` char(8) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `icreated` varchar(12) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_practice`)
) ENGINE=InnoDB AUTO_INCREMENT=22314 DEFAULT CHARSET=utf8mb4 COMMENT='Practising Address ';


-- medpcs.tr_sec_security definition

CREATE TABLE `tr_sec_security` (
  `secc_id` int(11) NOT NULL AUTO_INCREMENT,
  `secc_username` varchar(100) NOT NULL COMMENT 'application id as username',
  `secc_password` text NOT NULL,
  `secc_change_password` enum('Y','N') DEFAULT 'N',
  `secc_email` varchar(70) DEFAULT NULL,
  `secc_role` char(10) NOT NULL COMMENT 'refer lt_role (1 user can have >1 role)',
  `secc_user_status` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'Y-Active, N-Not Active',
  `secc_secret_question` int(2) DEFAULT NULL,
  `secc_secret_answer` varchar(45) DEFAULT NULL,
  `secc_ic_no` char(12) NOT NULL COMMENT 'ic no user keyin/applicant/authorized person',
  `secc_name` varchar(80) DEFAULT NULL,
  `secc_department` varchar(80) DEFAULT NULL COMMENT 'ukaps/ckaps',
  `secc_state` char(2) DEFAULT NULL,
  `secc_app_status` enum('0','1') DEFAULT NULL,
  `secc_licence_id` varchar(20) DEFAULT NULL,
  `secc_date_created` datetime NOT NULL,
  `secc_date_modified` datetime DEFAULT NULL,
  `secc_last_login` datetime DEFAULT NULL,
  `secc_ipaddress` varchar(50) DEFAULT NULL,
  `secc_browser` varchar(50) DEFAULT NULL,
  `secc_date_change_password` datetime DEFAULT NULL,
  PRIMARY KEY (`secc_id`),
  UNIQUE KEY `NewIndex1` (`secc_username`)
) ENGINE=InnoDB AUTO_INCREMENT=89246 DEFAULT CHARSET=utf8mb4 COMMENT='Store user login info (BFM1.1)';


-- medpcs.tr_sec_temp definition

CREATE TABLE `tr_sec_temp` (
  `secc_id` int(11) NOT NULL AUTO_INCREMENT,
  `secc_username` varchar(100) NOT NULL COMMENT 'application id as username',
  `secc_email` varchar(70) DEFAULT NULL,
  `secc_user_status` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT 'Y-Active, N-Not Active',
  `secc_ic_no` char(12) NOT NULL COMMENT 'ic no user keyin/applicant/authorized person',
  `secc_name` varchar(80) DEFAULT NULL,
  `secc_date_created` date NOT NULL,
  PRIMARY KEY (`secc_id`),
  UNIQUE KEY `NewIndex1` (`secc_username`)
) ENGINE=InnoDB AUTO_INCREMENT=87946 DEFAULT CHARSET=utf8mb4 COMMENT='Store user login info (BFM1.1)';


-- medpcs.tr_signing_response definition

CREATE TABLE `tr_signing_response` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trx_no` varchar(100) DEFAULT NULL COMMENT 'unique nonce number',
  `cert_start_date` datetime NOT NULL,
  `cert_end_date` datetime NOT NULL,
  `subject_dn` varchar(300) NOT NULL,
  `serial_no` int(100) NOT NULL,
  `key_type` varchar(10) DEFAULT NULL,
  `signed_data` text NOT NULL COMMENT 'hash data',
  `signing_time` datetime NOT NULL,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_site_visit definition

CREATE TABLE `tr_site_visit` (
  `sv_id` int(11) NOT NULL AUTO_INCREMENT,
  `sv_application_id` varchar(10) NOT NULL,
  `sv_start_date` date DEFAULT NULL,
  `sv_start_time` time DEFAULT NULL,
  `sv_end_date` date DEFAULT NULL,
  `sv_end_time` time DEFAULT NULL,
  PRIMARY KEY (`sv_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4971 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_submission definition

CREATE TABLE `tr_submission` (
  `sub_id` int(11) NOT NULL,
  `sub_appl_id` varchar(10) NOT NULL,
  `sub_category` int(11) DEFAULT NULL,
  `sub_desc` int(11) DEFAULT NULL,
  PRIMARY KEY (`sub_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_supporting_document definition

CREATE TABLE `tr_supporting_document` (
  `document_code` varchar(12) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(12) NOT NULL,
  `document_name` varchar(255) NOT NULL,
  `document_category` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `document_code` (`document_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_trx_bc definition

CREATE TABLE `tr_trx_bc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` varchar(11) NOT NULL,
  `app_type` int(11) NOT NULL,
  `reg_no` varchar(20) NOT NULL,
  `ref_key` varchar(100) DEFAULT NULL,
  `tx_hash` varchar(100) DEFAULT NULL,
  `qr_url` varchar(200) DEFAULT NULL,
  `status` enum('Y','N') DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'tarikh hantar payload',
  `date_updated` datetime DEFAULT NULL COMMENT 'last date terima hash',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_trx_otp definition

CREATE TABLE `tr_trx_otp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` varchar(11) NOT NULL,
  `user_nric` varchar(12) NOT NULL,
  `agencyID` varchar(45) NOT NULL,
  `mode` varchar(10) NOT NULL COMMENT 'prod, training',
  `otpExp` varchar(10) NOT NULL,
  `saluran` varchar(10) NOT NULL COMMENT 'mobile, email',
  `user_email` varchar(200) NOT NULL,
  `status_otp` enum('T','F') DEFAULT NULL,
  `trx_no` varchar(100) NOT NULL COMMENT 'response:unique nonce number',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_update` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_trx_signing definition

CREATE TABLE `tr_trx_signing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` varchar(12) NOT NULL,
  `user_nric` varchar(12) NOT NULL,
  `trx_no` varchar(100) NOT NULL COMMENT 'unique nonce number',
  `otpCode` varchar(10) NOT NULL,
  `data_original` text NOT NULL,
  `data` text NOT NULL,
  `signed_data` text NOT NULL,
  `pin` varchar(10) NOT NULL,
  `agencyID` varchar(45) NOT NULL,
  `mode` varchar(10) NOT NULL COMMENT 'prod, training',
  `sign_type` varchar(10) NOT NULL COMMENT 'data/hash',
  `dataSeq` varchar(1) NOT NULL,
  `status_signing` enum('T','F') DEFAULT NULL,
  `sessionId` varchar(35) NOT NULL,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_update` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_url definition

CREATE TABLE `tr_url` (
  `url_id` int(11) NOT NULL AUTO_INCREMENT,
  `url_application_id` varchar(10) DEFAULT NULL,
  `url_link` text,
  `url_status` enum('Y','N') DEFAULT NULL COMMENT 'last status for application',
  PRIMARY KEY (`url_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='record status for guided entry';


-- medpcs.tr_user_application definition

CREATE TABLE `tr_user_application` (
  `uap_id` int(11) NOT NULL AUTO_INCREMENT,
  `ic_no` varchar(12) NOT NULL COMMENT 'ic no applicant/ic person who make action',
  `application_id` varchar(10) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0' COMMENT 'refer lt_application_status.code (Default 0 - Draf)',
  `date` date DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `licence_id` varchar(10) DEFAULT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL COMMENT 'Date action taken',
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`uap_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='B.5 Clinic Registration/Application';


-- medpcs.tr_visiting_pract definition

CREATE TABLE `tr_visiting_pract` (
  `vp_id` int(11) NOT NULL AUTO_INCREMENT,
  `vp_ic_no` varchar(12) NOT NULL,
  `vp_designation` int(11) DEFAULT NULL,
  `vp_application_id` char(10) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`vp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Store Person in charge Information';


-- medpcs.tr_visiting_pract_contract definition

CREATE TABLE `tr_visiting_pract_contract` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vp_ic_no` varchar(12) DEFAULT NULL,
  `vp_frequency` int(11) DEFAULT NULL,
  `vp_responsibility` varchar(50) DEFAULT NULL COMMENT 'all responsibility divide by ''|''',
  `vp_application_id` char(10) DEFAULT NULL,
  `vp_emergency_info` text,
  `idcreated` varchar(12) DEFAULT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_zoning definition

CREATE TABLE `tr_zoning` (
  `id_zoning` int(11) NOT NULL AUTO_INCREMENT,
  `zoning_no` varchar(14) DEFAULT NULL,
  `ic_no` varchar(12) DEFAULT NULL,
  `applicant_name` varchar(80) DEFAULT NULL,
  `phfs_name` varchar(250) DEFAULT NULL,
  `date_end` date DEFAULT NULL COMMENT 'check expiry date',
  `used` enum('Y','N') DEFAULT 'N',
  `id_created` varchar(14) DEFAULT NULL COMMENT 'check has been used?',
  `date_created` datetime DEFAULT NULL,
  `id_modified` varchar(14) DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_zoning`),
  UNIQUE KEY `NewIndex1` (`zoning_no`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;


-- medpcs.x_employee definition

CREATE TABLE `x_employee` (
  `emp_id` int(11) NOT NULL,
  `emp_ci_id` varchar(10) NOT NULL,
  `emp_appi_id` mediumint(9) NOT NULL,
  `emp_category` mediumint(9) DEFAULT NULL,
  `emp_status` mediumint(9) DEFAULT NULL,
  `emp_type_practice` mediumint(9) DEFAULT NULL,
  `emp_person_update` text,
  `emp_job` char(30) DEFAULT NULL,
  `nokp` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`emp_ci_id`,`emp_appi_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.x_partnership_applicant_relation definition

CREATE TABLE `x_partnership_applicant_relation` (
  `par_id` int(11) NOT NULL AUTO_INCREMENT,
  `par_pi_id` text NOT NULL,
  `par_appi_id` mediumint(9) NOT NULL,
  `par_pi` mediumint(9) DEFAULT NULL,
  `nokp` varchar(12) DEFAULT NULL,
  `regno` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`par_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12538 DEFAULT CHARSET=utf8mb4;


-- medpcs.x_partnership_info definition

CREATE TABLE `x_partnership_info` (
  `pi_id` int(11) NOT NULL AUTO_INCREMENT,
  `pi_name` varchar(200) NOT NULL,
  `pi_comp_regis_no` varchar(10) NOT NULL,
  `pi_year_regis` mediumint(9) NOT NULL,
  `pi_add` varchar(300) NOT NULL,
  `pi_town` varchar(100) NOT NULL,
  `pi_state` mediumint(9) NOT NULL,
  `pi_postcode` decimal(5,0) NOT NULL,
  `pi_person_created` varchar(20) DEFAULT NULL,
  `pi_fax` varchar(15) DEFAULT NULL,
  `pi_mail` varchar(200) DEFAULT NULL,
  `pi_tel` varchar(15) DEFAULT NULL,
  `pi_category` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`pi_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5453 DEFAULT CHARSET=utf8mb4;


-- medpcs.x_person_info definition

CREATE TABLE `x_person_info` (
  `id_key` int(11) NOT NULL AUTO_INCREMENT,
  `appi_id` varchar(10) DEFAULT NULL,
  `appi_name` varchar(200) NOT NULL,
  `appi_nokp` varchar(12) NOT NULL,
  `appi_passport` varchar(15) DEFAULT NULL,
  `appi_dob` varchar(12) DEFAULT NULL,
  `appi_gender` char(1) DEFAULT NULL,
  `appi_race` varchar(5) DEFAULT NULL,
  `appi_nationality` char(1) DEFAULT NULL,
  `appi_email` varchar(200) DEFAULT NULL,
  `appi_declaration` varchar(10) DEFAULT NULL,
  `appi_person_created` varchar(20) DEFAULT NULL,
  `appi_title` varchar(4) DEFAULT NULL,
  `appi_phone` varchar(15) DEFAULT NULL,
  `appi_person_update` varchar(50) DEFAULT NULL,
  `application_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_key`)
) ENGINE=MyISAM AUTO_INCREMENT=131072 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_applicant_add definition

CREATE TABLE `z_applicant_add` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appa_id` varchar(10) DEFAULT NULL,
  `appa_appi_id` varchar(10) DEFAULT NULL,
  `appa_add` varchar(200) DEFAULT NULL,
  `appa_town` varchar(100) DEFAULT NULL,
  `appa_state` char(4) DEFAULT NULL,
  `appa_postcode` varchar(6) DEFAULT NULL,
  `appa_tel` varchar(12) DEFAULT NULL,
  `appa_fax` varchar(12) DEFAULT NULL,
  `appa_add_status` char(1) DEFAULT NULL,
  `appa_appl_id` varchar(10) DEFAULT NULL,
  `appa_other_state` varchar(30) DEFAULT NULL,
  `nokp` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=196606 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_applicant_experience definition

CREATE TABLE `z_applicant_experience` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appe_id` varchar(10) DEFAULT NULL,
  `appe_appi_id` varchar(10) DEFAULT NULL,
  `appe_experience` varchar(380) DEFAULT NULL,
  `appe_place` varchar(380) DEFAULT NULL,
  `appe_year` varchar(10) DEFAULT NULL,
  `YEAR` varchar(4) DEFAULT NULL,
  `appe_appl_id` varchar(10) DEFAULT NULL,
  `nokp` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=131071 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_application_payment definition

CREATE TABLE `z_application_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `apy_id` varchar(10) DEFAULT NULL,
  `apy_appl_id` varchar(10) DEFAULT NULL,
  `apy_resitno` varchar(250) DEFAULT NULL,
  `apy_bdmo` varchar(200) DEFAULT NULL,
  `apy_version` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_clinic_category definition

CREATE TABLE `z_clinic_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cc_id` varchar(10) DEFAULT NULL,
  `cc_status` varchar(10) DEFAULT NULL,
  `cc_remark` text,
  `cc_category` varchar(20) DEFAULT NULL,
  `cc_ci_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=196606 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_clinic_info definition

CREATE TABLE `z_clinic_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ci_id` varchar(10) DEFAULT NULL,
  `ci_name` varchar(200) DEFAULT NULL,
  `ci_date_register` varchar(10) DEFAULT NULL,
  `ci_add` varchar(200) DEFAULT NULL,
  `ci_town` varchar(100) DEFAULT NULL,
  `ci_district` varchar(4) DEFAULT NULL,
  `ci_state` varchar(4) DEFAULT NULL,
  `ci_tel` varchar(12) DEFAULT NULL,
  `ci_fax` varchar(12) DEFAULT NULL,
  `ci_pic` varchar(10) DEFAULT NULL,
  `ic_pic` varchar(12) NOT NULL,
  `ci_application_id` varchar(10) NOT NULL,
  `ic_applicant` varchar(12) NOT NULL,
  `ci_pi_id` varchar(10) DEFAULT NULL,
  `ci_regno` varchar(20) DEFAULT NULL,
  `ci_operate` varchar(10) DEFAULT NULL,
  `ci_operate_note` varchar(200) DEFAULT NULL,
  `ci_mail` varchar(100) DEFAULT NULL,
  `ci_postcode` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_employee definition

CREATE TABLE `z_employee` (
  `emp_id` int(11) NOT NULL,
  `emp_ci_id` varchar(10) NOT NULL,
  `emp_appi_id` mediumint(9) NOT NULL,
  `emp_category` varchar(20) DEFAULT NULL,
  `emp_status` mediumint(9) DEFAULT NULL,
  `emp_type_practice` mediumint(9) DEFAULT NULL,
  `emp_person_update` text,
  `emp_job` char(30) DEFAULT NULL,
  `nokp` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`emp_ci_id`,`emp_appi_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.z_financial definition

CREATE TABLE `z_financial` (
  `fin_id` int(11) NOT NULL,
  `fin_ci_id` varchar(10) NOT NULL,
  `fin_paid_local` double DEFAULT NULL,
  `fin_paid_foreign` double DEFAULT NULL,
  `fin_loan_local` double DEFAULT NULL,
  `fin_loan_foreign` double DEFAULT NULL,
  `fin_reason` text,
  PRIMARY KEY (`fin_ci_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.z_mco_relation definition

CREATE TABLE `z_mco_relation` (
  `mcr_id` int(11) NOT NULL,
  `mcr_appl_id` varchar(10) NOT NULL,
  `mcr_mng_id` mediumint(9) NOT NULL,
  `mng_date` text,
  `mng_type` mediumint(9) DEFAULT NULL,
  `mcr_person_update` text,
  PRIMARY KEY (`mcr_appl_id`,`mcr_mng_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;


-- medpcs.z_mng_care definition

CREATE TABLE `z_mng_care` (
  `mng_id` int(11) NOT NULL AUTO_INCREMENT,
  `mng_ci_id` varchar(10) NOT NULL,
  `mng_name` varchar(200) DEFAULT NULL,
  `mng_add` varchar(200) DEFAULT NULL,
  `mng_town` varchar(200) DEFAULT NULL,
  `mng_postcode` decimal(5,0) DEFAULT NULL,
  `mng_state` mediumint(9) DEFAULT NULL,
  `mng_tel` varchar(15) DEFAULT NULL,
  `mng_fax` varchar(15) DEFAULT NULL,
  `mng_mail` varchar(200) DEFAULT NULL,
  `mng_regis_no` varchar(12) DEFAULT NULL,
  `mng_date` text,
  `mng_contact` text,
  `mng_approval_no` text,
  `date` varchar(20) NOT NULL,
  PRIMARY KEY (`mng_id`)
) ENGINE=MyISAM AUTO_INCREMENT=966 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_money definition

CREATE TABLE `z_money` (
  `mn_id` int(11) NOT NULL AUTO_INCREMENT,
  `mn_no` text,
  `mn_amount` double DEFAULT NULL,
  `mn_date` text,
  `mn_login_id` text NOT NULL,
  `mn_type` mediumint(9) DEFAULT NULL,
  `mn_issued` varchar(50) DEFAULT NULL,
  `mn_category` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`mn_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14321 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_partnership_applicant_relation definition

CREATE TABLE `z_partnership_applicant_relation` (
  `par_id` int(11) NOT NULL AUTO_INCREMENT,
  `par_pi_id` text NOT NULL,
  `par_appi_id` mediumint(9) NOT NULL,
  `par_pi` mediumint(9) DEFAULT NULL,
  `nokp` varchar(12) DEFAULT NULL,
  `regno` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`par_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12538 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_partnership_info definition

CREATE TABLE `z_partnership_info` (
  `pi_id` int(11) NOT NULL AUTO_INCREMENT,
  `pi_name` varchar(200) NOT NULL,
  `pi_comp_regis_no` varchar(10) NOT NULL,
  `pi_year_regis` mediumint(9) NOT NULL,
  `pi_add` varchar(300) NOT NULL,
  `pi_town` varchar(100) NOT NULL,
  `pi_state` mediumint(9) NOT NULL,
  `pi_postcode` decimal(5,0) NOT NULL,
  `pi_person_created` varchar(20) DEFAULT NULL,
  `pi_fax` varchar(15) DEFAULT NULL,
  `pi_mail` varchar(200) DEFAULT NULL,
  `pi_tel` varchar(15) DEFAULT NULL,
  `pi_category` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`pi_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5453 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_person_info definition

CREATE TABLE `z_person_info` (
  `id_key` int(11) NOT NULL AUTO_INCREMENT,
  `appi_id` varchar(10) DEFAULT NULL,
  `appi_name` varchar(200) NOT NULL,
  `appi_nokp` varchar(12) NOT NULL,
  `appi_passport` varchar(15) DEFAULT NULL,
  `appi_dob` varchar(12) DEFAULT NULL,
  `appi_gender` char(1) DEFAULT NULL,
  `appi_race` varchar(5) DEFAULT NULL,
  `appi_nationality` char(1) DEFAULT NULL,
  `appi_email` varchar(200) DEFAULT NULL,
  `appi_declaration` varchar(10) DEFAULT NULL,
  `appi_person_created` varchar(20) DEFAULT NULL,
  `appi_title` varchar(4) DEFAULT NULL,
  `appi_phone` varchar(15) DEFAULT NULL,
  `appi_person_update` varchar(50) DEFAULT NULL,
  `application_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_key`)
) ENGINE=MyISAM AUTO_INCREMENT=131072 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_person_infox definition

CREATE TABLE `z_person_infox` (
  `id_key` int(11) NOT NULL AUTO_INCREMENT,
  `appi_id` varchar(10) DEFAULT NULL,
  `appi_name` varchar(200) NOT NULL,
  `appi_nokp` varchar(12) NOT NULL,
  `appi_passport` varchar(15) DEFAULT NULL,
  `appi_dob` varchar(12) DEFAULT NULL,
  `appi_gender` char(1) DEFAULT NULL,
  `appi_race` varchar(5) DEFAULT NULL,
  `appi_nationality` char(1) DEFAULT NULL,
  `appi_email` varchar(200) DEFAULT NULL,
  `appi_declaration` varchar(10) DEFAULT NULL,
  `appi_person_created` varchar(20) DEFAULT NULL,
  `appi_title` varchar(4) DEFAULT NULL,
  `appi_phone` varchar(15) DEFAULT NULL,
  `appi_person_update` varchar(50) DEFAULT NULL,
  `application_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_key`)
) ENGINE=MyISAM AUTO_INCREMENT=590 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_sec_security definition

CREATE TABLE `z_sec_security` (
  `secc_id` int(11) NOT NULL AUTO_INCREMENT,
  `secc_username` varchar(250) NOT NULL,
  `secc_user_status` char(1) NOT NULL,
  `secc_password` text NOT NULL,
  `secc_date_created` text NOT NULL,
  `secc_date_modified` text,
  `secc_acct_status` mediumint(9) NOT NULL,
  `secc_role` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`secc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=61723 DEFAULT CHARSET=utf8mb4;


-- medpcs.z_user_application definition

CREATE TABLE `z_user_application` (
  `uap_id` int(11) NOT NULL AUTO_INCREMENT,
  `uap_appi_id` text,
  `uap_application_id` varchar(15) NOT NULL,
  `uap_status` text,
  `uap_date` text,
  `uap_type` text,
  `uap_licence_id` text,
  `ic_applicant` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`uap_id`)
) ENGINE=MyISAM AUTO_INCREMENT=34735 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_checklist_detail definition

CREATE TABLE `lt_clinic_checklist_detail` (
  `id_chklist` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist` varchar(500) DEFAULT NULL,
  `desc_chklist_eng` varchar(500) NOT NULL,
  `desc_detail` text,
  `chklist_order` int(2) DEFAULT NULL,
  `sts_subchklist` enum('Y','N') DEFAULT NULL,
  `cat_chklist` int(11) DEFAULT NULL,
  `used` enum('PMC','PDC','BOTH') DEFAULT NULL,
  `idcreated` varchar(14) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` varchar(14) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_chklist`),
  KEY `fk_cat_chklist` (`cat_chklist`),
  CONSTRAINT `fk_cat_chklist` FOREIGN KEY (`cat_chklist`) REFERENCES `lt_clinic_checklist_category` (`id_cat`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_checklist_detail2 definition

CREATE TABLE `lt_clinic_checklist_detail2` (
  `id_chklist_detail` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist_detail` varchar(500) DEFAULT NULL,
  `desc_detail` text,
  `chklist_order` int(2) DEFAULT NULL,
  `sts_chklist` enum('Y','N') DEFAULT NULL,
  `id_chklist` int(11) NOT NULL,
  `chklist_label` varchar(3) DEFAULT NULL,
  `idcreated` varchar(14) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` varchar(14) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_chklist_detail`),
  KEY `fk_chklist_detail` (`id_chklist`),
  CONSTRAINT `fk_chklist_detail` FOREIGN KEY (`id_chklist`) REFERENCES `lt_clinic_checklist_detail` (`id_chklist`)
) ENGINE=InnoDB AUTO_INCREMENT=158 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_clinic_checklist_detail3 definition

CREATE TABLE `lt_clinic_checklist_detail3` (
  `id_chklist_detail2` int(11) NOT NULL AUTO_INCREMENT,
  `desc_chklist_detail` varchar(500) DEFAULT NULL,
  `desc_detail` text,
  `chklist_order` int(2) DEFAULT NULL,
  `chklist_label` varchar(10) DEFAULT NULL,
  `sts_chklist` enum('Y','N') DEFAULT NULL,
  `id_chklist_detail` int(11) NOT NULL,
  `idcreated` varchar(14) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `idupdated` varchar(14) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id_chklist_detail2`),
  KEY `fk_chklist_detail2` (`id_chklist_detail`) USING BTREE,
  CONSTRAINT `fk_chklist_detail2` FOREIGN KEY (`id_chklist_detail`) REFERENCES `lt_clinic_checklist_detail` (`id_chklist`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_designation definition

CREATE TABLE `lt_designation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `group_desc` varchar(100) NOT NULL,
  `id_designation_group` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description_UNIQUE` (`description`),
  UNIQUE KEY `code_UNIQUE` (`code`),
  KEY `id_designation_group_FK` (`id_designation_group`),
  CONSTRAINT `id_designation_group_FK` FOREIGN KEY (`id_designation_group`) REFERENCES `lt_designation_group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=324 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_facility_category definition

CREATE TABLE `lt_facility_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_type_of_facility` int(11) NOT NULL,
  `id_category` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_facility_FK` (`id_type_of_facility`),
  KEY `id_category_FK` (`id_category`),
  CONSTRAINT `id_category_FK` FOREIGN KEY (`id_category`) REFERENCES `lt_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_facility_FK` FOREIGN KEY (`id_type_of_facility`) REFERENCES `lt_type_of_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=273 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_facility_category_designation definition

CREATE TABLE `lt_facility_category_designation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_facility_category` int(11) NOT NULL,
  `id_designation` int(11) NOT NULL,
  `multi_design` enum('Y','N') NOT NULL DEFAULT 'N',
  `other_design` varchar(11) DEFAULT NULL,
  `quantity` int(3) NOT NULL DEFAULT '1',
  `ratio_a` int(2) NOT NULL DEFAULT '0',
  `ratio_b` int(2) NOT NULL DEFAULT '0',
  `shift` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_designation3_FK` (`id_designation`),
  KEY `id_facility_category_designation_FK` (`id_facility_category`),
  CONSTRAINT `id_designation3_FK` FOREIGN KEY (`id_designation`) REFERENCES `lt_designation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_facility_category_designation_FK` FOREIGN KEY (`id_facility_category`) REFERENCES `lt_facility_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_floorplan_item2 definition

CREATE TABLE `lt_floorplan_item2` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `act` varchar(10) DEFAULT NULL,
  `no` varchar(4) DEFAULT NULL,
  `item_bm` varchar(50) NOT NULL,
  `item_bi` varchar(50) DEFAULT NULL,
  `item_category` int(2) NOT NULL,
  `idcreated` int(11) NOT NULL,
  `dtcreated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `item_category` (`item_category`),
  CONSTRAINT `lt_floorplan_item2_ibfk_1` FOREIGN KEY (`item_category`) REFERENCES `lt_floorplan_item` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='looup table Senarai Semak Pelan Lantai';


-- medpcs.lt_fpclinic_detail definition

CREATE TABLE `lt_fpclinic_detail` (
  `id_fpsubitem` int(12) NOT NULL AUTO_INCREMENT,
  `desc_bm` varchar(100) DEFAULT NULL COMMENT 'DESC. IN BM',
  `desc_eng` varchar(100) DEFAULT NULL COMMENT 'DESC IN BI',
  `id_fpcat` int(12) DEFAULT NULL COMMENT 'LT_FPCLINIC_CATEGORY.ID',
  `chklist_order` int(2) DEFAULT NULL,
  `act` varchar(100) DEFAULT NULL COMMENT 'AKTA YANG DIRUJUK',
  `used` varchar(10) DEFAULT NULL COMMENT 'BOTH OR PDC ONLY OR PMC ONLY',
  `check_status` enum('Y','N') DEFAULT NULL,
  `sv_status` enum('Y','N') DEFAULT NULL,
  `sts_subchklist` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`id_fpsubitem`),
  KEY `item_FK` (`id_fpcat`),
  CONSTRAINT `item_FK` FOREIGN KEY (`id_fpcat`) REFERENCES `lt_fpclinic_category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_equipment_designation definition

CREATE TABLE `lt_phfs_equipment_designation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_phfs_equipment_fk` int(11) NOT NULL,
  `id_designation_fk` int(11) NOT NULL,
  `quantity` int(3) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `id_phfs_equipment1_FK` (`id_phfs_equipment_fk`),
  KEY `id_designation2_FK` (`id_designation_fk`),
  CONSTRAINT `id_designation2_FK` FOREIGN KEY (`id_designation_fk`) REFERENCES `lt_designation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_phfs_equipment1_FK` FOREIGN KEY (`id_phfs_equipment_fk`) REFERENCES `lt_phfs_equipment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_fee_schedule_l definition

CREATE TABLE `lt_phfs_fee_schedule_l` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phfs_type` int(11) DEFAULT NULL,
  `sub` varchar(5) DEFAULT NULL,
  `sub_desc` varchar(50) DEFAULT NULL,
  `total_beds` int(11) DEFAULT NULL,
  `fee` decimal(10,2) DEFAULT NULL,
  `fee_desc` varchar(50) DEFAULT NULL,
  `fee_per_bed` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lt_phfs_fee_schedule_l_ibfk_1` (`phfs_type`),
  CONSTRAINT `lt_phfs_fee_schedule_l_ibfk_1` FOREIGN KEY (`phfs_type`) REFERENCES `lt_phfs_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_phfs_type_service definition

CREATE TABLE `lt_phfs_type_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_phfs_type` int(11) NOT NULL,
  `id_service_type` int(11) NOT NULL,
  `id_service` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `phfs_type_FK` (`id_phfs_type`),
  KEY `service_type_FK` (`id_service_type`),
  KEY `service_FK2` (`id_service`),
  CONSTRAINT `phfs_type_FK` FOREIGN KEY (`id_phfs_type`) REFERENCES `lt_phfs_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK2` FOREIGN KEY (`id_service`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_type_FK` FOREIGN KEY (`id_service_type`) REFERENCES `lt_service_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=305 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_pic_cat definition

CREATE TABLE `lt_pic_cat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_phfs_type_pic` int(11) DEFAULT NULL,
  `id_designation_pic` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_phfs_type_pic` (`id_phfs_type_pic`),
  KEY `id_designation_pic` (`id_designation_pic`),
  CONSTRAINT `lt_pic_cat_ibfk_1` FOREIGN KEY (`id_phfs_type_pic`) REFERENCES `lt_phfs_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `lt_pic_cat_ibfk_2` FOREIGN KEY (`id_designation_pic`) REFERENCES `lt_designation` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_sub_service_designation definition

CREATE TABLE `lt_sub_service_designation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_sub_service` int(11) DEFAULT NULL,
  `id_designation` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `id_sub_specialty_FK` (`id_sub_service`),
  KEY `id_designation1_FK` (`id_designation`),
  CONSTRAINT `sub_design_FK` FOREIGN KEY (`id_designation`) REFERENCES `lt_designation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service1_FK` FOREIGN KEY (`id_sub_service`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=300 DEFAULT CHARSET=utf8mb4;


-- medpcs.lt_sub_specialty_designation definition

CREATE TABLE `lt_sub_specialty_designation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_sub_specialty` int(11) DEFAULT NULL,
  `id_designation` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_sub_specialty_FK` (`id_sub_specialty`),
  KEY `id_designation1_FK` (`id_designation`),
  CONSTRAINT `id_designation1_FK` FOREIGN KEY (`id_designation`) REFERENCES `lt_designation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_sub_specialty_FK` FOREIGN KEY (`id_sub_specialty`) REFERENCES `lt_sub_specialty` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_business_venture_members definition

CREATE TABLE `tr_business_venture_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ic_no` varchar(12) NOT NULL COMMENT 'ic no/pasport no',
  `registration_no` varchar(30) DEFAULT NULL,
  `authorize_person` enum('Y','N') DEFAULT 'N' COMMENT 'Authorize Person : Y=Yes,N=No',
  `application_id` char(20) DEFAULT NULL,
  `date_created` date NOT NULL,
  `date_modified` date DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `NewIndex1` (`ic_no`,`application_id`),
  KEY `FK_tr_business_venture_members` (`application_id`),
  CONSTRAINT `FK_tr_business_venture_members` FOREIGN KEY (`application_id`) REFERENCES `tr_business_venture` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=52303 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_adminreview definition

CREATE TABLE `tr_clinic_adminreview` (
  `id_rev` int(11) NOT NULL AUTO_INCREMENT,
  `id_kronologi` int(11) DEFAULT NULL COMMENT 'fk tr_clinic_kronologi',
  `ci_id` int(11) DEFAULT NULL COMMENT 'ci id - refer to tr_clinic_info',
  `application_id` char(8) DEFAULT NULL COMMENT 'fk from tr_clinic_application',
  `review_id` int(11) DEFAULT NULL COMMENT 'refer lt_clinic_adminreview',
  `review_by` varchar(80) NOT NULL COMMENT 'person make review',
  `reviews` text NOT NULL COMMENT 'remarks',
  `review_date` datetime DEFAULT NULL COMMENT 'tarikh ulasan',
  `PB3Pfile` varchar(200) DEFAULT NULL COMMENT 'senarai nama file upload',
  `idcreated` varchar(80) DEFAULT NULL COMMENT 'id person who create review',
  `dtcreated` datetime DEFAULT NULL COMMENT 'date created',
  `dtupdated` datetime DEFAULT NULL COMMENT 'date updated',
  PRIMARY KEY (`id_rev`),
  KEY `kod_adminreview` (`review_id`),
  CONSTRAINT `kod_adminreview` FOREIGN KEY (`review_id`) REFERENCES `lt_clinic_adminreview` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71927 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_application definition

CREATE TABLE `tr_clinic_application` (
  `ci_appl_id` int(11) NOT NULL AUTO_INCREMENT,
  `ci_id` int(11) DEFAULT NULL COMMENT 'FK:tr_clinic_info',
  `curr_appid` char(8) DEFAULT NULL,
  `ci_app_type` int(11) DEFAULT NULL COMMENT 'rujuk cnt_applicationID.ID',
  `ci_regno` varchar(20) DEFAULT NULL COMMENT 'clinic registration number',
  `ci_application_id` char(8) NOT NULL COMMENT 'current application id',
  `ci_fileno` varchar(50) DEFAULT NULL COMMENT 'No. Fail CKAPS',
  `ci_name` varchar(200) DEFAULT NULL,
  `ci_date_established` date DEFAULT NULL,
  `ci_address` varchar(200) DEFAULT NULL,
  `ci_town` varchar(7) DEFAULT NULL,
  `ci_district` varchar(4) DEFAULT NULL,
  `ci_postcode` varchar(6) DEFAULT NULL,
  `ci_state` varchar(2) DEFAULT NULL,
  `ci_tel` varchar(14) DEFAULT NULL,
  `ci_fax` varchar(14) DEFAULT NULL,
  `ci_email` varchar(100) DEFAULT NULL,
  `ci_applicant` varchar(12) DEFAULT NULL COMMENT 'ic applicant',
  `ci_pic` varchar(12) DEFAULT NULL COMMENT 'ic no person incharge',
  `ci_authperson` varchar(12) DEFAULT NULL COMMENT 'ic no authorized person',
  `hours` enum('Y','N') DEFAULT NULL COMMENT 'Does your clinic 24 hours?',
  `ci_week` text COMMENT 'if the clinic operating certain week',
  `ci_pi_id` varchar(11) DEFAULT NULL,
  `ci_area_interest` enum('Y','N') DEFAULT 'N' COMMENT 'area interest services',
  `ci_reason` text COMMENT 'ammendment/transfer/dispose reason',
  `ci_disrupted` enum('Y','N') DEFAULT NULL COMMENT 'Will any existing healthcare service be disrupted prior to or during the transfer/amend/dispose exercise?',
  `ci_safety` text COMMENT 'measures taken to ensure safety and security of patient and records, etc',
  `ci_addr_patient_record` varchar(200) DEFAULT NULL,
  `id_currstatus` int(11) DEFAULT NULL COMMENT 'current application status (refer ltg_flowstatus)',
  `submission_date` date DEFAULT NULL COMMENT 'Online submission date by applicant',
  `ci_approved_date` datetime DEFAULT NULL COMMENT 'tarikh kelulusan DG',
  `ckaps_received_date` date DEFAULT NULL COMMENT 'Tarikh penerimaan borang manual oleh CKAPS',
  `ukaps_received_date` date DEFAULT NULL COMMENT 'Tarikh penerimaan borang manual oleh UKAPS',
  `ukaps_file_no` varchar(30) DEFAULT NULL COMMENT 'No Fail UKAPS',
  `ci_close_date` date DEFAULT NULL COMMENT 'Closing date',
  `ci_close_date_comment` varchar(200) DEFAULT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`ci_appl_id`),
  UNIQUE KEY `ci_application_id` (`ci_application_id`),
  KEY `fk_tr_clinic_application` (`ci_id`),
  CONSTRAINT `tr_clinic_application_ibfk_1` FOREIGN KEY (`ci_id`) REFERENCES `tr_clinic_info` (`ci_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53679 DEFAULT CHARSET=utf8mb4 COMMENT='One Clinic may have many application';


-- medpcs.tr_clinic_kronologi definition

CREATE TABLE `tr_clinic_kronologi` (
  `id_kronologi` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action` int(11) DEFAULT NULL COMMENT 'refer to ltg_flowstatus.id_status',
  `action_date` datetime NOT NULL,
  `action_by` varchar(80) NOT NULL COMMENT 'Name person who make action',
  `action_reference` varchar(12) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'action sama ada SAVE atau SUBMIT',
  `action_reason` text,
  `ci_id` int(11) DEFAULT NULL,
  `application_id` char(8) DEFAULT NULL COMMENT 'fk frm tr_clinic_application',
  PRIMARY KEY (`id_kronologi`),
  KEY `ci_application_id` (`application_id`),
  CONSTRAINT `FK_tr_clinic_kronologi` FOREIGN KEY (`application_id`) REFERENCES `tr_clinic_application` (`ci_application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=129634 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_clinic_type definition

CREATE TABLE `tr_clinic_type` (
  `ct_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `ct_type` enum('PMC','PDC') DEFAULT NULL COMMENT 'PMC-Medical Clinic, PDC-Dental Clinic',
  `ct_mobile_clinic` enum('Y','N') DEFAULT 'N',
  `ct_type_practice` enum('S','G') DEFAULT NULL COMMENT 'S-Solo Practice, G-Group Service',
  `ct_business_venture` enum('SP','PS','BC','SC') DEFAULT NULL COMMENT 'SP-Sole Proprieter, PS-Partnership, BC-Body corporate, \nSC-Society',
  `ct_type_services` enum('GP','SS') DEFAULT NULL COMMENT 'GP-General Practrice, SS-Specialist Services',
  `ct_physical_linkage` enum('Y','N') DEFAULT NULL,
  `phfs_linkage` varchar(100) DEFAULT NULL,
  `ct_admin_linkage` enum('Y','N') DEFAULT NULL,
  `admin_linkage` varchar(100) DEFAULT NULL,
  `ct_org_linkage` enum('Y','N') DEFAULT NULL,
  `org_linkage` varchar(100) DEFAULT NULL,
  `ownership_premis` enum('OW','L','R','OT') DEFAULT NULL,
  `premis_other` varchar(100) DEFAULT NULL,
  `ct_application_id` char(8) NOT NULL,
  `ct_status` enum('0','1','2','3','4') DEFAULT '1' COMMENT 'Status Pertukaran BV :0=Not Approved, 1=Approved, 2=New Application 3=Delete 4=History',
  `ct_status_2` enum('0','1','2','3','4') DEFAULT '1' COMMENT 'Status pertukaran servis',
  `idcreated` varchar(12) NOT NULL COMMENT 'id who created record',
  `dtcreated` datetime NOT NULL COMMENT 'datetime record created',
  `idupdated` varchar(12) DEFAULT NULL COMMENT 'id who modified record',
  `dtupdated` datetime DEFAULT NULL COMMENT 'datetime record modified',
  PRIMARY KEY (`ct_id`),
  KEY `FK_tr_clinic_type` (`ct_application_id`),
  CONSTRAINT `FK_tr_clinic_type` FOREIGN KEY (`ct_application_id`) REFERENCES `tr_clinic_application` (`ci_application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43453 DEFAULT CHARSET=utf8mb4 COMMENT='Store type of clinic (1-PMC, 2-PDC)';


-- medpcs.tr_person_experience definition

CREATE TABLE `tr_person_experience` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `experience` varchar(380) NOT NULL,
  `place` varchar(380) NOT NULL,
  `from` date NOT NULL COMMENT 'format mm-yyyy',
  `to` date NOT NULL COMMENT 'format mm-yyyy',
  `application_id` varchar(12) NOT NULL,
  `ic_no` varchar(12) CHARACTER SET utf8mb4 NOT NULL,
  `experience_status` enum('1','2') NOT NULL DEFAULT '1' COMMENT '2 - amend',
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ic_no` (`ic_no`),
  CONSTRAINT `tr_person_experience_ibfk_1` FOREIGN KEY (`ic_no`) REFERENCES `tr_person_info` (`ic_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4728791 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_person_professional definition

CREATE TABLE `tr_person_professional` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registering_body` varchar(3) NOT NULL COMMENT 'refer lt_professional_body',
  `registration_no` varchar(12) DEFAULT NULL,
  `regis_year` year(4) DEFAULT NULL,
  `current_apc` varchar(15) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `ic_no` varchar(12) CHARACTER SET utf8mb4 NOT NULL,
  `profesional_status` enum('1','2') DEFAULT '1' COMMENT '2-amend',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ic_no` (`ic_no`),
  CONSTRAINT `tr_person_professional_ibfk_1` FOREIGN KEY (`ic_no`) REFERENCES `tr_person_info` (`ic_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1877052 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_person_qualification definition

CREATE TABLE `tr_person_qualification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `institution` char(4) NOT NULL COMMENT 'refer lt_institution',
  `list_of_qualification` int(11) NOT NULL COMMENT 'refer lt_qualification_list',
  `year` year(4) NOT NULL,
  `application_id` char(8) NOT NULL,
  `ic_no` varchar(12) CHARACTER SET utf8mb4 NOT NULL,
  `qualification_status` enum('1','2') DEFAULT '1' COMMENT '2-amend',
  `date_created` datetime NOT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ic_no` (`ic_no`),
  CONSTRAINT `tr_person_qualification_ibfk_1` FOREIGN KEY (`ic_no`) REFERENCES `tr_person_info` (`ic_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=535176 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_application definition

CREATE TABLE `tr_phfs_application` (
  `uap_id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `app_type` enum('A','A-A','L-A','AM','AL','T-A','D-A','E-A','M','TT','TC','LC','AC','D-C','LA','TA') DEFAULT NULL COMMENT 'A-(Registration)A-A(Approval)L-A(Licensing)AM(Amendment)AL(Amendment License)TA(Transfer/Assignment)D-A(Disposal)AE-A(Extension), R(Renew Licensing)',
  `name` varchar(300) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `address3` varchar(100) DEFAULT NULL,
  `town` varchar(7) DEFAULT NULL,
  `postcode` varchar(6) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `district` varchar(4) DEFAULT NULL,
  `ic_no` varchar(12) DEFAULT NULL COMMENT 'ic no applicant',
  `date` date DEFAULT NULL,
  `id_currstatus` int(11) DEFAULT NULL COMMENT 'application status - refer to ltg_flowstatus.id_status',
  `submission_date` date DEFAULT NULL,
  `phfs_fileno` varchar(50) DEFAULT NULL,
  `ckaps_received_date` date DEFAULT NULL,
  `approval_no` varchar(45) DEFAULT NULL,
  `approved_date` datetime DEFAULT NULL,
  `extension_no` varchar(45) DEFAULT NULL,
  `extension_approved_date` datetime DEFAULT NULL,
  `license_no` varchar(45) DEFAULT NULL,
  `license_approved_date` datetime DEFAULT NULL,
  `license_type_app` enum('1','2') DEFAULT NULL COMMENT '1-new, 2-renew',
  `cur_no` varchar(45) DEFAULT NULL,
  `cur_appid` char(8) DEFAULT NULL,
  `id_phfs` int(11) DEFAULT NULL COMMENT 'foreign key (tr_phfs)',
  `phone_no` varchar(14) DEFAULT NULL,
  `fax_no` varchar(14) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `website` varchar(45) DEFAULT NULL,
  `reason` varchar(200) DEFAULT NULL COMMENT 'ammendment/transfer/dispose reason',
  `disrupted` enum('Y','N') DEFAULT NULL COMMENT 'Will any existing healthcare service be disrupted prior to or during the transfer/amend/dispose exercise?',
  `safety` varchar(200) DEFAULT NULL COMMENT 'measures taken to ensure safety and security of patient and records, etc',
  `close_date` date DEFAULT NULL COMMENT 'Closing date',
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL COMMENT 'Date action taken',
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  `app_capacity_size` text,
  PRIMARY KEY (`uap_id`),
  UNIQUE KEY `NewIndex1` (`application_id`),
  KEY `id_phfs` (`id_phfs`),
  CONSTRAINT `tr_phfs_application_ibfk_1` FOREIGN KEY (`id_phfs`) REFERENCES `tr_phfs` (`id_phfs`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1360 DEFAULT CHARSET=utf8mb4 COMMENT='Rekod setiap Application bg PHFS. 1PHFS many Application';


-- medpcs.tr_phfs_capacity definition

CREATE TABLE `tr_phfs_capacity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `id_type_of_facility` int(11) NOT NULL,
  `id_category` int(11) NOT NULL,
  `id_capacity` int(11) NOT NULL,
  `quantity` int(4) NOT NULL,
  `total` int(4) DEFAULT NULL,
  `quantity_app` int(4) NOT NULL,
  `total_app` int(4) DEFAULT NULL,
  `status_cat` int(2) NOT NULL DEFAULT '0' COMMENT '0=applicant, 1=admin',
  `status_service` int(2) DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_tr_phfs_capacity` (`application_id`,`id_type_of_facility`,`id_category`,`id_capacity`),
  KEY `id_category1_FK` (`id_category`),
  KEY `id_capacity1_FK` (`id_capacity`),
  KEY `id_type_of_facility_FK` (`id_type_of_facility`),
  CONSTRAINT `id_capacity1_FK` FOREIGN KEY (`id_capacity`) REFERENCES `lt_capacity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_category1_FK` FOREIGN KEY (`id_category`) REFERENCES `lt_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_type_of_facility_FK` FOREIGN KEY (`id_type_of_facility`) REFERENCES `lt_type_of_facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1974 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_clinical definition

CREATE TABLE `tr_phfs_clinical` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `sub_services` int(11) NOT NULL,
  `phfs_type_service` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `apply_l` int(2) DEFAULT NULL COMMENT '0=not apply, 1=apply',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`),
  KEY `service_FK1` (`services`),
  KEY `sub_service_FK1` (`sub_services`),
  CONSTRAINT `application_id_FK4` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK5` FOREIGN KEY (`services`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service_FK5` FOREIGN KEY (`sub_services`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_clinical_support definition

CREATE TABLE `tr_phfs_clinical_support` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `sub_services` int(11) NOT NULL,
  `phfs_type_service` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `apply_l` int(2) DEFAULT NULL COMMENT '0=not apply, 1=apply',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`),
  KEY `service_FK1` (`services`),
  KEY `sub_service_FK1` (`sub_services`),
  CONSTRAINT `application_id_FK5` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK6` FOREIGN KEY (`services`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service_FK6` FOREIGN KEY (`sub_services`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_equipment definition

CREATE TABLE `tr_phfs_equipment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` char(8) NOT NULL,
  `id_phfs_equipment` int(11) NOT NULL,
  `description` varchar(50) DEFAULT NULL,
  `quantity` int(3) NOT NULL DEFAULT '1',
  `quantity_app` int(3) DEFAULT NULL,
  `status_service` int(2) DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `username` (`application_id`),
  KEY `id_phfs_equipment_FK` (`id_phfs_equipment`),
  KEY `idx_tr_phfs_equipment` (`application_id`,`id_phfs_equipment`),
  CONSTRAINT `id_phfs_equipment_FK` FOREIGN KEY (`id_phfs_equipment`) REFERENCES `lt_phfs_equipment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_financial definition

CREATE TABLE `tr_phfs_financial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `local_capital` decimal(17,2) NOT NULL,
  `foreign_capital` decimal(17,2) DEFAULT NULL,
  `loan` decimal(17,2) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `NewIndex2` (`application_id`),
  KEY `NewIndex1` (`application_id`),
  CONSTRAINT `FK_tr_phfs_financial` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1365 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_inpatient definition

CREATE TABLE `tr_phfs_inpatient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `sub_services` int(11) NOT NULL,
  `phfs_type_service` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `apply_l` int(2) DEFAULT NULL COMMENT '0=not apply, 1=apply',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`),
  KEY `service_FK1` (`services`),
  KEY `sub_service_FK1` (`sub_services`),
  CONSTRAINT `FK_tr_phfs_inpatient` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK1` FOREIGN KEY (`services`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service_FK1` FOREIGN KEY (`sub_services`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1443 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_inpatient_service definition

CREATE TABLE `tr_phfs_inpatient_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `sub_services` int(11) NOT NULL,
  `phfs_type_service` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `apply_l` int(2) DEFAULT NULL COMMENT '0=not apply, 1=apply',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`),
  KEY `service_FK1` (`services`),
  KEY `sub_service_FK1` (`sub_services`),
  CONSTRAINT `application_id_FK2` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK3` FOREIGN KEY (`services`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service_FK3` FOREIGN KEY (`sub_services`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_level_capacity definition

CREATE TABLE `tr_phfs_level_capacity` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `id_phfs_capacity` int(12) DEFAULT NULL,
  `block_name` int(50) DEFAULT NULL,
  `level` int(2) DEFAULT NULL,
  `quantity` int(12) DEFAULT NULL,
  `total` int(12) DEFAULT NULL,
  `flag` int(2) DEFAULT '0' COMMENT '0=applicant, 1=admin',
  `status_assign` int(2) DEFAULT '1' COMMENT '0=not approved, 1=approved',
  `application_id` char(8) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `level_restrict` (`id_phfs_capacity`,`level`,`application_id`,`flag`,`block_name`) USING BTREE,
  KEY `id_tr_phfs_block` (`block_name`),
  CONSTRAINT `id_phfs_capacity` FOREIGN KEY (`id_phfs_capacity`) REFERENCES `tr_phfs_capacity` (`id`),
  CONSTRAINT `id_tr_phfs_block` FOREIGN KEY (`block_name`) REFERENCES `tr_phfs_block` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3897 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_manpower2 definition

CREATE TABLE `tr_phfs_manpower2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` varchar(12) NOT NULL,
  `tab_type` varchar(10) NOT NULL,
  `id_tab_type` int(11) DEFAULT NULL,
  `id_designation` int(11) NOT NULL,
  `other_desg` varchar(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `quantity_app` int(11) DEFAULT NULL,
  `status_service` int(11) DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_desig_FK` (`id_designation`),
  CONSTRAINT `id_desig_FK` FOREIGN KEY (`id_designation`) REFERENCES `lt_designation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5428 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_nonclinical definition

CREATE TABLE `tr_phfs_nonclinical` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `sub_services` int(11) NOT NULL,
  `phfs_type_service` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `apply_l` int(2) DEFAULT NULL COMMENT '0=not apply, 1=apply',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`),
  KEY `service_FK1` (`services`),
  KEY `sub_service_FK1` (`sub_services`),
  CONSTRAINT `application_id_FK8` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK9` FOREIGN KEY (`services`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service_FK9` FOREIGN KEY (`sub_services`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_outpatient definition

CREATE TABLE `tr_phfs_outpatient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `sub_services` int(11) NOT NULL,
  `phfs_type_service` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `apply_l` int(2) DEFAULT NULL COMMENT '0=not apply, 1=apply',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`),
  KEY `service_FK1` (`services`),
  KEY `sub_service_FK1` (`sub_services`),
  CONSTRAINT `application_id_FK7` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK8` FOREIGN KEY (`services`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service_FK8` FOREIGN KEY (`sub_services`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_ownership definition

CREATE TABLE `tr_phfs_ownership` (
  `id_phfs_ownership` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT 'lt_phfs_ownership_type',
  `type_others` int(11) DEFAULT NULL COMMENT 'lt_phfs_ownership_type_others',
  `category` enum('I','P') DEFAULT NULL COMMENT 'I-Individual, P-PARTNERSHIP/BODY CORPORATE/SOCIETY',
  `nationality` int(11) DEFAULT NULL,
  `individual_person` varchar(12) DEFAULT NULL COMMENT 'if category = Individual (ic/pasport no owner)',
  `registration_no` varchar(15) DEFAULT NULL COMMENT 'if Category= PARTNERSHIP/BODY CORPORATE/SOCIETY',
  `name` varchar(150) NOT NULL,
  `application_id` char(8) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id_phfs_ownership`),
  KEY `FK_tr_phfs_ownership` (`application_id`),
  CONSTRAINT `FK_tr_phfs_ownership` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1356 DEFAULT CHARSET=utf8mb4 COMMENT='store info section C.Ownership';


-- medpcs.tr_phfs_patient definition

CREATE TABLE `tr_phfs_patient` (
  `id_phfs_patient` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_phfs_patient`),
  KEY `NewIndex1` (`application_id`),
  CONSTRAINT `FK_tr_phfs_patient` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_patient_care definition

CREATE TABLE `tr_phfs_patient_care` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `sub_services` int(11) NOT NULL,
  `phfs_type_service` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `apply_l` int(2) DEFAULT NULL COMMENT '0=not apply, 1=apply',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `application_id_FK6` (`application_id`),
  KEY `service_FK7` (`services`),
  KEY `sub_service_FK7` (`sub_services`),
  CONSTRAINT `application_id_FK6` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK7` FOREIGN KEY (`services`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service_FK7` FOREIGN KEY (`sub_services`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_projection definition

CREATE TABLE `tr_phfs_projection` (
  `id_phfs_projection` int(11) NOT NULL AUTO_INCREMENT,
  `current` text,
  `five_years` text,
  `ten_years` text,
  `fiftheen_years` int(11) DEFAULT NULL,
  `twenty_years` int(11) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  UNIQUE KEY `id_UNIQUE` (`id_phfs_projection`),
  KEY `NewIndex1` (`application_id`),
  CONSTRAINT `FK_tr_phfs_projection` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1357 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_proposed_site definition

CREATE TABLE `tr_phfs_proposed_site` (
  `application_id` char(8) NOT NULL,
  `state_population` text NOT NULL,
  `local_autority` int(11) NOT NULL,
  `town` varchar(45) NOT NULL,
  `district` varchar(11) NOT NULL,
  `state` varchar(2) NOT NULL,
  `local_population` text NOT NULL,
  `town_population` text NOT NULL,
  `district_population` text NOT NULL,
  `id_proposed_site` int(11) NOT NULL AUTO_INCREMENT,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id_proposed_site`),
  KEY `NewIndex1` (`application_id`),
  CONSTRAINT `FK_tr_phfs_proposed_site` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1355 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_type definition

CREATE TABLE `tr_phfs_type` (
  `id_phfs_type` int(11) NOT NULL AUTO_INCREMENT,
  `phfs_type` int(11) NOT NULL COMMENT 'A.1 Type of healthcare facility (lt_phfs_type)',
  `application_id` char(8) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  UNIQUE KEY `id_UNIQUE` (`id_phfs_type`),
  KEY `NewIndex1` (`application_id`),
  CONSTRAINT `FK_tr_phfs_type` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1403 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_reference_business_venture_members definition

CREATE TABLE `tr_reference_business_venture_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ic_no` varchar(12) CHARACTER SET utf8mb4 NOT NULL COMMENT 'ic no/pasport no',
  `registration_no` varchar(30) CHARACTER SET utf8mb4 NOT NULL,
  `id_created` varchar(12) CHARACTER SET utf8mb4 DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `id_modified` varchar(12) CHARACTER SET utf8mb4 DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tr_reference_business_venture_members` (`registration_no`),
  CONSTRAINT `FK_tr_reference_business_venture_members` FOREIGN KEY (`registration_no`) REFERENCES `tr_reference_business_venture` (`registration_no`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19204 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_reference_experience definition

CREATE TABLE `tr_reference_experience` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `experience` varchar(380) NOT NULL,
  `place` varchar(380) NOT NULL,
  `from` date NOT NULL,
  `to` date NOT NULL,
  `ic_no` varchar(12) NOT NULL,
  `id_created` varchar(12) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `id_modified` varchar(12) DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tr_reference_experience` (`ic_no`),
  CONSTRAINT `FK_tr_reference_experience` FOREIGN KEY (`ic_no`) REFERENCES `tr_reference` (`ic_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=166420 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_reference_professional definition

CREATE TABLE `tr_reference_professional` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registering_body` varchar(45) NOT NULL,
  `registration_no` varchar(12) DEFAULT NULL,
  `regis_year` year(4) DEFAULT NULL,
  `current_apc` varchar(15) DEFAULT NULL,
  `ic_no` varchar(12) NOT NULL,
  `id_created` varchar(12) DEFAULT NULL COMMENT 'Application ID created',
  `date_created` datetime DEFAULT NULL,
  `id_modified` varchar(12) DEFAULT NULL COMMENT 'Application ID Modified',
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tr_reference_professional` (`ic_no`),
  CONSTRAINT `FK_tr_reference_professional` FOREIGN KEY (`ic_no`) REFERENCES `tr_reference` (`ic_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28809 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_reference_qualification definition

CREATE TABLE `tr_reference_qualification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `institution` int(11) NOT NULL,
  `list_of_qualification` int(11) NOT NULL,
  `year` year(4) NOT NULL,
  `ic_no` varchar(12) NOT NULL,
  `date_created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `NewIndex1` (`institution`,`list_of_qualification`,`ic_no`),
  KEY `FK_tr_reference_qualification` (`ic_no`),
  CONSTRAINT `FK_tr_reference_qualification` FOREIGN KEY (`ic_no`) REFERENCES `tr_reference` (`ic_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23299 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_specialist definition

CREATE TABLE `tr_specialist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(3) DEFAULT NULL COMMENT 'refer lt_service',
  `ser_specialist_id` int(3) NOT NULL,
  `others` varchar(100) DEFAULT NULL,
  `service_status` enum('1','2','3','4') DEFAULT '1',
  `application_id` char(8) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`),
  CONSTRAINT `FK_tr_specialist` FOREIGN KEY (`application_id`) REFERENCES `tr_clinic_type` (`ct_application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6777 DEFAULT CHARSET=utf8mb4 COMMENT='store info A.2 Services (Modul Registration)';


-- medpcs.tr_zoning_validity definition

CREATE TABLE `tr_zoning_validity` (
  `id_zoning_valid` int(11) NOT NULL AUTO_INCREMENT,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `meeting` varchar(100) DEFAULT NULL,
  `zoning_no` varchar(14) NOT NULL,
  `id_created` varchar(14) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `id_modified` varchar(14) DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id_zoning_valid`),
  KEY `id_zoning` (`zoning_no`),
  CONSTRAINT `FK_tr_zoning_validity` FOREIGN KEY (`zoning_no`) REFERENCES `tr_zoning` (`zoning_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_phfs_ambulatory definition

CREATE TABLE `tr_phfs_ambulatory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `services` int(11) NOT NULL,
  `sub_services` int(11) NOT NULL,
  `phfs_type_service` int(11) NOT NULL,
  `description` varchar(25) DEFAULT NULL,
  `application_id` char(8) NOT NULL,
  `status_service` int(2) DEFAULT '1' COMMENT '0=not approve, 1=approve',
  `apply_l` int(1) DEFAULT NULL COMMENT '0=not apply, 1=apply',
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `idcreated` char(16) DEFAULT NULL,
  `idupdated` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`application_id`),
  KEY `service_FK1` (`services`),
  KEY `sub_service_FK1` (`sub_services`),
  CONSTRAINT `application_id_FK3` FOREIGN KEY (`application_id`) REFERENCES `tr_phfs_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_FK4` FOREIGN KEY (`services`) REFERENCES `lt_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_service_FK4` FOREIGN KEY (`sub_services`) REFERENCES `lt_sub_service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;


-- medpcs.tr_partnership_applicant_relation definition

CREATE TABLE `tr_partnership_applicant_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ic_no` varchar(12) NOT NULL,
  `par_pi` int(11) DEFAULT NULL,
  `application_id` varchar(10) NOT NULL,
  `idcreated` varchar(12) NOT NULL,
  `dtcreated` date NOT NULL,
  `idupdated` varchar(12) DEFAULT NULL,
  `dtupdated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Record A.4 (Individual)';