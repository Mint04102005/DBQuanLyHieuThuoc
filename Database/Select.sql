-- 1. Danh sách các thuốc có giá bán trên 100,000
SELECT ten, giaban FROM thuoc WHERE giaban > 100000;

-- 2. Tên khách hàng và số điện thoại đã từng mua hàng
SELECT DISTINCT kh.hoten, kh.sdt
FROM khachhang kh
JOIN hoadon hd ON kh.id = hd.idkh;

-- 3. Tổng số lượng bán ra của từng loại thuốc
SELECT idthuoc, SUM(soluong) AS tong_ban
FROM ChiTietHoaDon
GROUP BY idthuoc;

-- 4. Doanh thu của từng ngày trong tháng 4/2024
SELECT DATE(thoigiantao) AS ngay, SUM(tongtien) AS doanhthu
FROM hoadon
WHERE EXTRACT(MONTH FROM thoigiantao) = 4 AND EXTRACT(YEAR FROM thoigiantao) = 2024
GROUP BY DATE(thoigiantao);

-- 5. Nhân viên có doanh số trên 500,000
SELECT nv.idnv, nv.hoten, SUM(hd.tongtien) AS doanhso
FROM nhanvien nv
JOIN hoadon hd ON nv.idnv = hd.idnv
GROUP BY nv.idnv, nv.hoten
HAVING SUM(hd.tongtien) > 500000;

-- 6. Số hóa đơn mỗi khách hàng đã mua
SELECT kh.hoten, COUNT(*) AS sohoadon
FROM khachhang kh
JOIN hoadon hd ON kh.id = hd.idkh
GROUP BY kh.hoten;

--7.Liệt kê danh sách khách hàng, số tiền đã mua, và số loại thuốc khác nhau mà họ đã mua
--hiển thị những người chi < 	1.000.000 VND.
SELECT 
    kh.id AS MaKhachHang,
    kh.hoten AS HoTen,
    COUNT(DISTINCT cthd.idthuoc) AS SoLoaiThuoc,
    SUM(cthd.dongia * cthd.soluong) AS TongTienMua
FROM 
    khachhang kh
JOIN hoadon hd ON kh.id = hd.idkh
JOIN chitiethoadon cthd ON hd.idhd = cthd.idhd
GROUP BY 
    kh.id, kh.hoten
HAVING 
    SUM(cthd.dongia * cthd.soluong) < 1000000
ORDER BY 
    TongTienMua DESC;
--8.Tìm 3 loại thuốc bán chạy nhất, dựa trên tổng số lượng đã bán, kèm theo tên thuốc và tổng doanh thu từ mỗi loại thuốc.
SELECT 
    t.ten AS TenThuoc,
    SUM(cthd.soluong) AS TongSoLuongBan,
    SUM(cthd.soluong * cthd.dongia) AS DoanhThu
FROM 
    chitiethoadon cthd
JOIN thuoc t ON cthd.idthuoc = t.id_thuoc
GROUP BY 
    t.ten
ORDER BY 
    TongSoLuongBan DESC
LIMIT 3;

