-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.3 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for pawcare_db
CREATE DATABASE IF NOT EXISTS `pawcare_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pawcare_db`;

-- Dumping structure for table pawcare_db.aksesoris
CREATE TABLE IF NOT EXISTS `aksesoris` (
  `id_produk` varchar(15) NOT NULL,
  `ukuran` varchar(30) DEFAULT NULL,
  `warna` varchar(40) DEFAULT NULL,
  `bahan` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id_produk`),
  CONSTRAINT `fk_aksesoris_produk` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.booking
CREATE TABLE IF NOT EXISTS `booking` (
  `id_booking` varchar(15) NOT NULL,
  `id_pemilik` varchar(15) NOT NULL,
  `id_hewan` varchar(15) NOT NULL,
  `id_layanan` varchar(15) NOT NULL,
  `tanggal_booking` date NOT NULL,
  `jam_booking` time NOT NULL,
  `status_booking` enum('Menunggu','Dikonfirmasi','Proses','Selesai','Dibatalkan') NOT NULL DEFAULT 'Menunggu',
  `catatan` text,
  PRIMARY KEY (`id_booking`),
  KEY `fk_booking_pemilik` (`id_pemilik`),
  KEY `fk_booking_hewan` (`id_hewan`),
  KEY `fk_booking_layanan` (`id_layanan`),
  CONSTRAINT `fk_booking_hewan` FOREIGN KEY (`id_hewan`) REFERENCES `hewan` (`id_hewan`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_booking_layanan` FOREIGN KEY (`id_layanan`) REFERENCES `layanan` (`id_layanan`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_booking_pemilik` FOREIGN KEY (`id_pemilik`) REFERENCES `pemilik` (`id_pemilik`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.detail_penjualan_produk
CREATE TABLE IF NOT EXISTS `detail_penjualan_produk` (
  `id_detail` int NOT NULL AUTO_INCREMENT,
  `id_penjualan` varchar(15) NOT NULL,
  `id_produk` varchar(15) NOT NULL,
  `jumlah` int NOT NULL,
  `harga_satuan` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`jumlah` * `harga_satuan`)) STORED,
  PRIMARY KEY (`id_detail`),
  KEY `fk_detail_penjualan` (`id_penjualan`),
  KEY `fk_detail_produk` (`id_produk`),
  CONSTRAINT `fk_detail_penjualan` FOREIGN KEY (`id_penjualan`) REFERENCES `penjualan_produk` (`id_penjualan`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detail_produk` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `detail_penjualan_produk_chk_1` CHECK ((`jumlah` > 0)),
  CONSTRAINT `detail_penjualan_produk_chk_2` CHECK ((`harga_satuan` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.dokter_hewan
CREATE TABLE IF NOT EXISTS `dokter_hewan` (
  `id_dokter` varchar(15) NOT NULL,
  `nama_dokter` varchar(100) NOT NULL,
  `spesialisasi` varchar(80) DEFAULT NULL,
  `no_str` varchar(50) DEFAULT NULL,
  `no_telepon` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_dokter`),
  UNIQUE KEY `no_str` (`no_str`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.hewan
CREATE TABLE IF NOT EXISTS `hewan` (
  `id_hewan` varchar(15) NOT NULL,
  `id_pemilik` varchar(15) NOT NULL,
  `nama_hewan` varchar(100) NOT NULL,
  `jenis_hewan` enum('Kucing','Anjing','Burung','Kelinci','Lainnya') NOT NULL,
  `ras` varchar(60) DEFAULT NULL,
  `jenis_kelamin` enum('Jantan','Betina') NOT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `berat_kg` decimal(5,2) DEFAULT NULL,
  `catatan_khusus` text,
  PRIMARY KEY (`id_hewan`),
  KEY `fk_hewan_pemilik` (`id_pemilik`),
  CONSTRAINT `fk_hewan_pemilik` FOREIGN KEY (`id_pemilik`) REFERENCES `pemilik` (`id_pemilik`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.invoice
CREATE TABLE IF NOT EXISTS `invoice` (
  `id_invoice` varchar(15) NOT NULL,
  `nomor_invoice` varchar(30) NOT NULL,
  `id_pemilik` varchar(15) NOT NULL,
  `tanggal_invoice` date NOT NULL DEFAULT (curdate()),
  `total_tagihan` decimal(12,2) NOT NULL DEFAULT '0.00',
  `status_pembayaran` enum('Belum Lunas','Lunas','Dibatalkan') NOT NULL DEFAULT 'Belum Lunas',
  PRIMARY KEY (`id_invoice`),
  UNIQUE KEY `nomor_invoice` (`nomor_invoice`),
  KEY `fk_invoice_pemilik` (`id_pemilik`),
  CONSTRAINT `fk_invoice_pemilik` FOREIGN KEY (`id_pemilik`) REFERENCES `pemilik` (`id_pemilik`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `invoice_chk_1` CHECK ((`total_tagihan` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.invoice_item
CREATE TABLE IF NOT EXISTS `invoice_item` (
  `id_item` int NOT NULL AUTO_INCREMENT,
  `id_invoice` varchar(15) NOT NULL,
  `tipe_item` enum('Booking','PenjualanProduk') NOT NULL,
  `id_booking` varchar(15) DEFAULT NULL,
  `id_penjualan` varchar(15) DEFAULT NULL,
  `deskripsi` varchar(150) NOT NULL,
  `jumlah` int NOT NULL DEFAULT '1',
  `harga_satuan` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`jumlah` * `harga_satuan`)) STORED,
  PRIMARY KEY (`id_item`),
  KEY `fk_item_invoice` (`id_invoice`),
  KEY `fk_item_booking` (`id_booking`),
  KEY `fk_item_penjualan` (`id_penjualan`),
  CONSTRAINT `fk_item_booking` FOREIGN KEY (`id_booking`) REFERENCES `booking` (`id_booking`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_item_invoice` FOREIGN KEY (`id_invoice`) REFERENCES `invoice` (`id_invoice`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_item_penjualan` FOREIGN KEY (`id_penjualan`) REFERENCES `penjualan_produk` (`id_penjualan`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `invoice_item_chk_1` CHECK ((`jumlah` > 0)),
  CONSTRAINT `invoice_item_chk_2` CHECK ((`harga_satuan` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.layanan
CREATE TABLE IF NOT EXISTS `layanan` (
  `id_layanan` varchar(15) NOT NULL,
  `nama_layanan` varchar(100) NOT NULL,
  `kategori_layanan` enum('Grooming','Penitipan','Konsultasi','Vaksinasi','Lainnya') NOT NULL,
  `deskripsi` text,
  `harga` decimal(12,2) NOT NULL,
  `durasi_menit` int DEFAULT NULL,
  PRIMARY KEY (`id_layanan`),
  CONSTRAINT `layanan_chk_1` CHECK ((`harga` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.obat_vitamin
CREATE TABLE IF NOT EXISTS `obat_vitamin` (
  `id_produk` varchar(15) NOT NULL,
  `dosis` varchar(100) NOT NULL,
  `komposisi` text,
  `tanggal_kadaluarsa` date NOT NULL,
  `butuh_resep` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_produk`),
  CONSTRAINT `fk_obat_produk` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.pembayaran
CREATE TABLE IF NOT EXISTS `pembayaran` (
  `id_pembayaran` varchar(15) NOT NULL,
  `id_invoice` varchar(15) NOT NULL,
  `tanggal_bayar` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `metode_pembayaran` enum('Tunai','Transfer Bank','QRIS','E-Wallet','Kartu') NOT NULL,
  `jumlah_bayar` decimal(12,2) NOT NULL,
  `referensi_pembayaran` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id_pembayaran`),
  KEY `fk_pembayaran_invoice` (`id_invoice`),
  CONSTRAINT `fk_pembayaran_invoice` FOREIGN KEY (`id_invoice`) REFERENCES `invoice` (`id_invoice`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `pembayaran_chk_1` CHECK ((`jumlah_bayar` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.pemilik
CREATE TABLE IF NOT EXISTS `pemilik` (
  `id_pemilik` varchar(15) NOT NULL,
  `nama_pemilik` varchar(100) NOT NULL,
  `no_telepon` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `alamat` text,
  `tanggal_daftar` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`id_pemilik`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.penjualan_produk
CREATE TABLE IF NOT EXISTS `penjualan_produk` (
  `id_penjualan` varchar(15) NOT NULL,
  `id_pemilik` varchar(15) NOT NULL,
  `tanggal_penjualan` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_harga` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_penjualan`),
  KEY `fk_penjualan_pemilik` (`id_pemilik`),
  CONSTRAINT `fk_penjualan_pemilik` FOREIGN KEY (`id_pemilik`) REFERENCES `pemilik` (`id_pemilik`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `penjualan_produk_chk_1` CHECK ((`total_harga` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.produk
CREATE TABLE IF NOT EXISTS `produk` (
  `id_produk` varchar(15) NOT NULL,
  `nama_produk` varchar(120) NOT NULL,
  `kategori_produk` enum('ObatVitamin','ProdukMakanan','Aksesoris') NOT NULL,
  `harga` decimal(12,2) NOT NULL,
  `stok` int NOT NULL DEFAULT '0',
  `deskripsi` text,
  PRIMARY KEY (`id_produk`),
  CONSTRAINT `produk_chk_1` CHECK ((`harga` >= 0)),
  CONSTRAINT `produk_chk_2` CHECK ((`stok` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.produk_makanan
CREATE TABLE IF NOT EXISTS `produk_makanan` (
  `id_produk` varchar(15) NOT NULL,
  `berat_gram` int NOT NULL,
  `rasa` varchar(60) DEFAULT NULL,
  `target_usia` enum('Puppy/Kitten','Adult','Senior','Semua Usia') DEFAULT 'Semua Usia',
  `tanggal_kadaluarsa` date NOT NULL,
  PRIMARY KEY (`id_produk`),
  CONSTRAINT `fk_makanan_produk` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `produk_makanan_chk_1` CHECK ((`berat_gram` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.rekam_kesehatan
CREATE TABLE IF NOT EXISTS `rekam_kesehatan` (
  `id_rekam` varchar(15) NOT NULL,
  `id_hewan` varchar(15) NOT NULL,
  `id_dokter` varchar(15) NOT NULL,
  `id_booking` varchar(15) DEFAULT NULL,
  `tanggal_periksa` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `keluhan` text NOT NULL,
  `diagnosa` text NOT NULL,
  `tindakan` text,
  `resep_obat` text,
  `catatan` text,
  PRIMARY KEY (`id_rekam`),
  KEY `fk_rekam_hewan` (`id_hewan`),
  KEY `fk_rekam_dokter` (`id_dokter`),
  KEY `fk_rekam_booking` (`id_booking`),
  CONSTRAINT `fk_rekam_booking` FOREIGN KEY (`id_booking`) REFERENCES `booking` (`id_booking`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_rekam_dokter` FOREIGN KEY (`id_dokter`) REFERENCES `dokter_hewan` (`id_dokter`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_rekam_hewan` FOREIGN KEY (`id_hewan`) REFERENCES `hewan` (`id_hewan`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table pawcare_db.riwayat_vaksinasi
CREATE TABLE IF NOT EXISTS `riwayat_vaksinasi` (
  `id_vaksinasi` int NOT NULL AUTO_INCREMENT,
  `id_hewan` varchar(15) NOT NULL,
  `id_rekam` varchar(15) DEFAULT NULL,
  `nama_vaksin` varchar(100) NOT NULL,
  `tanggal_vaksin` date NOT NULL,
  `tanggal_vaksin_berikutnya` date DEFAULT NULL,
  PRIMARY KEY (`id_vaksinasi`),
  KEY `fk_vaksin_hewan` (`id_hewan`),
  KEY `fk_vaksin_rekam` (`id_rekam`),
  CONSTRAINT `fk_vaksin_hewan` FOREIGN KEY (`id_hewan`) REFERENCES `hewan` (`id_hewan`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_vaksin_rekam` FOREIGN KEY (`id_rekam`) REFERENCES `rekam_kesehatan` (`id_rekam`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for view pawcare_db.v_laporan_transaksi
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `v_laporan_transaksi` (
	`id_invoice` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`nomor_invoice` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`tanggal_invoice` DATE NOT NULL,
	`id_pemilik` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`nama_pemilik` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`total_tagihan` DECIMAL(12,2) NOT NULL,
	`status_pembayaran` ENUM('Belum Lunas','Lunas','Dibatalkan') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`metode_pembayaran` ENUM('Tunai','Transfer Bank','QRIS','E-Wallet','Kartu') NULL COLLATE 'utf8mb4_0900_ai_ci',
	`tanggal_bayar` DATETIME NULL,
	`jumlah_bayar` DECIMAL(12,2) NULL
) ENGINE=MyISAM;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `v_laporan_transaksi`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_laporan_transaksi` AS select `i`.`id_invoice` AS `id_invoice`,`i`.`nomor_invoice` AS `nomor_invoice`,`i`.`tanggal_invoice` AS `tanggal_invoice`,`p`.`id_pemilik` AS `id_pemilik`,`p`.`nama_pemilik` AS `nama_pemilik`,`i`.`total_tagihan` AS `total_tagihan`,`i`.`status_pembayaran` AS `status_pembayaran`,`pb`.`metode_pembayaran` AS `metode_pembayaran`,`pb`.`tanggal_bayar` AS `tanggal_bayar`,`pb`.`jumlah_bayar` AS `jumlah_bayar` from ((`invoice` `i` join `pemilik` `p` on((`i`.`id_pemilik` = `p`.`id_pemilik`))) left join `pembayaran` `pb` on((`i`.`id_invoice` = `pb`.`id_invoice`)));

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
