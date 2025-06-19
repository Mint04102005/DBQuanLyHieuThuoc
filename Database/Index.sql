-- 1. Tăng tốc tìm kiếm khách hàng theo số điện thoại
-- Truy vấn trước khi tạo index
EXPLAIN ANALYZE
SELECT * FROM khachhang WHERE sdt = '0901234567';

-- Tạo index
CREATE INDEX idx_khachhang_sdt ON khachhang(sdt);



-- 2. Tăng tốc truy vấn hóa đơn theo nhân viên
-- Truy vấn trước khi tạo index
EXPLAIN ANALYZE
SELECT * FROM hoadon WHERE idnv = 'NV01';

-- Tạo index
CREATE INDEX idx_hoadon_idnv ON hoadon(idnv);



-- 3. Tăng tốc tìm kiếm thuốc theo tên
-- Truy vấn trước khi tạo index
EXPLAIN ANALYZE
SELECT * FROM thuoc WHERE ten ILIKE '%paracetamol%';

-- Tạo index
CREATE INDEX idx_thuoc_ten ON thuoc(ten);



-- 4. Tăng tốc JOIN bảng ChiTietHoaDon theo idhd
-- Truy vấn trước khi tạo index
EXPLAIN ANALYZE
SELECT * FROM chitiethoadon WHERE idhd = 'HD01';

-- Tạo index
CREATE INDEX idx_cthd_idhd ON chitiethoadon(idhd);



-- 5. Tăng tốc phân tích hóa đơn theo thời gian tạo
-- Truy vấn trước khi tạo index
EXPLAIN ANALYZE
SELECT * FROM hoadon WHERE thoigiantao >= '2024-01-01';

-- Tạo index
CREATE INDEX idx_hoadon_thoigiantao ON hoadon(thoigiantao);



-- 6. Tăng tốc thống kê nhập hàng theo nhà cung cấp
-- Truy vấn trước khi tạo index
EXPLAIN ANALYZE
SELECT * FROM phieunhaphang WHERE idncc = 'NCC01';

-- Tạo index
CREATE INDEX idx_phieunhaphang_idncc ON phieunhaphang(idncc);
