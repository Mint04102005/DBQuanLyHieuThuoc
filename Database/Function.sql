-- 1. Tính tổng tiền của 1 hóa đơn theo ID
CREATE OR REPLACE FUNCTION fn_chi_tiet_hoadon(p_idhd TEXT)
RETURNS TABLE (
    ten_thuoc VARCHAR,
    soluong INTEGER,
    dongia FLOAT,
    thanhtien FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.ten,
        ct.soluong,
        ct.dongia,
        ct.soluong * ct.dongia AS thanhtien
    FROM 
        chitiethoadon ct
    JOIN 
        thuoc t ON ct.idthuoc = t.id_thuoc
    WHERE 
        ct.idhd = p_idhd;
END;
$$ LANGUAGE plpgsql;

--Test
SELECT fn_chi_tiet_hoadon('TJ6QM5STW');


-- 2. Lấy tổng số lượng thuốc đã bán theo mã thuốc
CREATE OR REPLACE FUNCTION fn_tongban_thuoc(p_idthuoc TEXT)
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(soluong), 0)
        FROM ChiTietHoaDon
        WHERE idthuoc = p_idthuoc
    );
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT fn_tongban_thuoc('VFZCHLHIE');


-- 3. Đếm số hóa đơn của một khách hàng
CREATE OR REPLACE FUNCTION fn_dem_hoadon_khach(p_idkh TEXT)
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM hoadon
        WHERE idkh = p_idkh
    );
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT fn_dem_hoadon_khach('ABCD12345');


-- 4. Tính số tiền trung bình 1 ngày của 1 nhân viên
CREATE OR REPLACE FUNCTION fn_tb_doanhso_nv(p_idnv TEXT)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT AVG(tongtien)
        FROM hoadon
        WHERE idnv = p_idnv
    );
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT fn_tb_doanhso_nv('AVHGD2GD6');

DROP FUNCTION IF EXISTS fn_ktra_tonkho(VARCHAR);
--5.Xem thuốc còn hàng tồn kho không
CREATE FUNCTION fn_ktra_tonkho(ma_thuoc VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    sl INT;
    ten_thuoc VARCHAR;
    trangthai VARCHAR;
BEGIN
    SELECT ten, soluongton INTO ten_thuoc, sl
    FROM thuoc
    WHERE id_thuoc = ma_thuoc;

    IF sl IS NULL THEN
        RETURN 'Không tìm thấy thuốc';
    ELSIF sl <= 0 THEN
        trangthai := 'Hết hàng';
    ELSIF sl <= 10 THEN
        trangthai := 'Sắp hết';
    ELSE
        trangthai := 'Còn hàng';
    END IF;

    RETURN ten_thuoc || ' - ' || trangthai;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT fn_ktra_tonkho('798E63U16');


-- 6. Tên khách hàng từ mã hóa đơn
CREATE OR REPLACE FUNCTION fn_tenkh_tu_hoadon(p_idhd TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT kh.hoten
        FROM hoadon hd
        JOIN khachhang kh ON kh.id = hd.idkh
        WHERE hd.idhd = p_idhd
    );
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT fn_tenkh_tu_hoadon('R4DDC67Q0');
