-- ============================================================
-- KS.STUDIO PHOTOGRAPHY MANAGEMENT SYSTEM
-- Combined Database Schema - Full Version (PostgreSQL)
-- ============================================================

-- DROP ALL EXISTING OBJECTS
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS photo CASCADE;
DROP TABLE IF EXISTS outdoor CASCADE;
DROP TABLE IF EXISTS indoor CASCADE;
DROP TABLE IF EXISTS package CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS photographer CASCADE;

-- ============================================================
-- PHOTOGRAPHER TABLE
-- ============================================================
CREATE TABLE photographer (
    pgid SERIAL PRIMARY KEY,
    pgsnr INTEGER,
    pgname VARCHAR(150) NOT NULL,
    pgph VARCHAR(15),
    pgemail VARCHAR(255) NOT NULL,
    pgpass VARCHAR(100) NOT NULL,
    pgrole VARCHAR(100) DEFAULT 'junior',
    pgstatus VARCHAR(20) DEFAULT 'active',
    pgcreated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT photographer_email_uk UNIQUE (pgemail),
    CONSTRAINT photographer_mgr_fk FOREIGN KEY (pgsnr) REFERENCES photographer(pgid),
    CONSTRAINT chk_pg_role CHECK (pgrole IN ('senior', 'junior', 'intern')),
    CONSTRAINT chk_pg_status CHECK (pgstatus IN ('active', 'inactive'))
);

-- ============================================================
-- CLIENT TABLE
-- ============================================================
CREATE TABLE client (
    clid SERIAL PRIMARY KEY,
    clname VARCHAR(150) NOT NULL,
    clph VARCHAR(15),
    clemail VARCHAR(255) NOT NULL,
    clpass VARCHAR(100) NOT NULL,
    claddress VARCHAR(255),
    clstatus VARCHAR(20) DEFAULT 'active',
    clcreated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT client_email_uk UNIQUE (clemail),
    CONSTRAINT chk_cl_status CHECK (clstatus IN ('active', 'inactive'))
);

-- ============================================================
-- PACKAGE TABLE
-- ============================================================
CREATE TABLE package (
    pkgid SERIAL PRIMARY KEY,
    pkgname VARCHAR(255) NOT NULL,
    pkgprice NUMERIC(10,2) CHECK (pkgprice > 0),
    pkgcateg VARCHAR(100) NOT NULL,
    pkgduration NUMERIC(5,2),
    eventtype VARCHAR(100),
    pkgdesc VARCHAR(500),
    pkgstatus VARCHAR(20) DEFAULT 'active',
    createdby INTEGER,
    createddate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_pkg_categ CHECK (pkgcateg IN ('Indoor', 'Outdoor')),
    CONSTRAINT chk_pkg_event CHECK (eventtype IN ('Wedding', 'Birthday', 'Corporate', 'Portrait', 'Other')),
    CONSTRAINT chk_pkg_status CHECK (pkgstatus IN ('active', 'inactive')),
    CONSTRAINT package_creator_fk FOREIGN KEY (createdby) REFERENCES photographer(pgid)
);

-- ============================================================
-- INDOOR TABLE
-- ============================================================
CREATE TABLE indoor (
    pkgid INTEGER PRIMARY KEY,
    numofpax INTEGER DEFAULT 1,
    backgtype VARCHAR(100) DEFAULT 'White',
    CONSTRAINT indoor_pkg_fk FOREIGN KEY (pkgid) REFERENCES package(pkgid) ON DELETE CASCADE,
    CONSTRAINT chk_bg_type CHECK (backgtype IN ('White', 'Black', 'Green Screen', 'Custom'))
);

-- ============================================================
-- OUTDOOR TABLE
-- ============================================================
CREATE TABLE outdoor (
    pkgid INTEGER PRIMARY KEY,
    distance NUMERIC(6,2) DEFAULT 0,
    distancepriceperkm NUMERIC(8,2) DEFAULT 0,
    location VARCHAR(200),
    CONSTRAINT outdoor_pkg_fk FOREIGN KEY (pkgid) REFERENCES package(pkgid) ON DELETE CASCADE
);

-- ============================================================
-- PHOTO TABLE (Photo folder links for clients)
-- ============================================================
CREATE TABLE photo (
    folderid SERIAL PRIMARY KEY,
    folderlink VARCHAR(500),
    foldername VARCHAR(100),
    folderdupload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uploadedby INTEGER,
    notesforclient VARCHAR(500),
    CONSTRAINT photo_uploader_fk FOREIGN KEY (uploadedby) REFERENCES photographer(pgid)
);

-- ============================================================
-- BOOKING TABLE
-- ============================================================
CREATE TABLE booking (
    bookingid SERIAL PRIMARY KEY,
    clid INTEGER NOT NULL,
    pgid INTEGER,
    pkgid INTEGER NOT NULL,
    folderid INTEGER,
    bookdate DATE NOT NULL,
    bookstarttime TIMESTAMP,
    bookendtime TIMESTAMP,
    bookpax INTEGER DEFAULT 1 CHECK (bookpax > 0),
    booklocation VARCHAR(200),
    totalprice NUMERIC(10,2),
    bookstatus VARCHAR(50) DEFAULT 'Pending',
    booknotes VARCHAR(500),
    bookcreated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT booking_client_fk FOREIGN KEY (clid) REFERENCES client(clid),
    CONSTRAINT booking_photographer_fk FOREIGN KEY (pgid) REFERENCES photographer(pgid),
    CONSTRAINT booking_package_fk FOREIGN KEY (pkgid) REFERENCES package(pkgid),
    CONSTRAINT booking_photo_fk FOREIGN KEY (folderid) REFERENCES photo(folderid),
    CONSTRAINT chk_book_status CHECK (bookstatus IN ('Pending', 'Waiting Approval', 'Confirmed', 'Completed', 'Cancelled'))
);

-- ============================================================
-- PAYMENT TABLE
-- ============================================================
CREATE TABLE payment (
    payid SERIAL PRIMARY KEY,
    bookingid INTEGER NOT NULL,
    depopref VARCHAR(100),
    depopdate DATE,
    deporeceipt VARCHAR(500),
    fullpref VARCHAR(100),
    fullpdate DATE,
    fullreceipt VARCHAR(500),
    paidamount NUMERIC(10,2) DEFAULT 0 CHECK (paidamount >= 0),
    remamount NUMERIC(10,2) DEFAULT 0 CHECK (remamount >= 0),
    receipts VARCHAR(500),
    paystatus VARCHAR(20) DEFAULT 'pending',
    paynotes VARCHAR(500),
    verifiedby INTEGER,
    verifieddate DATE,
    CONSTRAINT payment_booking_fk FOREIGN KEY (bookingid) REFERENCES booking(bookingid),
    CONSTRAINT payment_verifier_fk FOREIGN KEY (verifiedby) REFERENCES photographer(pgid),
    CONSTRAINT chk_pay_status CHECK (paystatus IN ('pending', 'submitted', 'partial', 'verified', 'rejected'))
);

-- ============================================================
-- INSERT SAMPLE DATA
-- ============================================================

-- Photographers
INSERT INTO photographer (pgname, pgph, pgemail, pgpass, pgrole, pgstatus)
VALUES ('Admin Senior', '019-1234567', 'senior@ksstudio.com', 'admin123', 'senior', 'active');

INSERT INTO photographer (pgsnr, pgname, pgph, pgemail, pgpass, pgrole, pgstatus)
VALUES (1, 'Ahmad Junior', '019-7654321', 'junior@ksstudio.com', 'junior123', 'junior', 'active');

INSERT INTO photographer (pgsnr, pgname, pgph, pgemail, pgpass, pgrole, pgstatus)
VALUES (1, 'Sarah Intern', '019-5555555', 'intern@ksstudio.com', 'intern123', 'intern', 'active');

-- Clients
INSERT INTO client (clname, clph, clemail, clpass, claddress)
VALUES ('Ali Ahmad', '019-1111111', 'ali@email.com', 'client123', 'Kuala Lumpur');

INSERT INTO client (clname, clph, clemail, clpass, claddress)
VALUES ('Siti Aminah', '019-2222222', 'siti@email.com', 'client123', 'Selangor');

INSERT INTO client (clname, clph, clemail, clpass, claddress)
VALUES ('John Tan', '019-3333333', 'john@email.com', 'client123', 'Penang');

-- Indoor Packages
INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Family Portrait', 150, 'Indoor', 0.5, 'Portrait', 'Perfect for family portraits up to 5 people', 1);
INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (1, 5, 'White');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Corporate Headshot', 200, 'Indoor', 1, 'Corporate', 'Professional headshots for business profiles', 1);
INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (2, 10, 'White');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Birthday Party', 300, 'Indoor', 2, 'Birthday', 'Indoor birthday party photography coverage', 1);
INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (3, 20, 'Custom');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Graduation Portrait', 180, 'Indoor', 1, 'Portrait', 'Graduation photos with cap and gown', 1);
INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (4, 3, 'Black');

-- Outdoor Packages
INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Wedding Photoshoot', 500, 'Outdoor', 3, 'Wedding', 'Full wedding coverage with professional photographers', 1);
INSERT INTO outdoor (pkgid, distance, distancepriceperkm, location) VALUES (5, 50, 2, 'Kuala Lumpur');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Pre-Wedding Shoot', 600, 'Outdoor', 4, 'Wedding', 'Beautiful outdoor pre-wedding session', 1);
INSERT INTO outdoor (pkgid, distance, distancepriceperkm, location) VALUES (6, 30, 2.5, 'Selangor');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Event Coverage', 800, 'Outdoor', 5, 'Corporate', 'Complete corporate event photography coverage', 1);
INSERT INTO outdoor (pkgid, distance, distancepriceperkm, location) VALUES (7, 100, 3, 'Nationwide');

-- Sample Bookings
INSERT INTO booking (clid, pgid, pkgid, bookdate, bookstarttime, bookendtime, bookpax, booklocation, totalprice, bookstatus)
VALUES (1, 1, 1, '2026-01-20', 
        '2026-01-20 10:00:00',
        '2026-01-20 10:30:00',
        5, 'KS Studio', 150, 'Confirmed');

INSERT INTO booking (clid, pgid, pkgid, bookdate, bookstarttime, bookendtime, bookpax, booklocation, totalprice, bookstatus)
VALUES (2, 1, 5, '2026-01-25', 
        '2026-01-25 09:00:00',
        '2026-01-25 12:00:00',
        2, 'Taman Tasik Titiwangsa', 600, 'Waiting Approval');

INSERT INTO booking (clid, pgid, pkgid, bookdate, bookstarttime, bookendtime, bookpax, booklocation, totalprice, bookstatus)
VALUES (3, 2, 2, '2026-01-22', 
        '2026-01-22 14:00:00',
        '2026-01-22 15:00:00',
        10, 'KS Studio', 200, 'Pending');

-- Sample Payments
INSERT INTO payment (bookingid, depopref, depopdate, paidamount, remamount, receipts, paystatus)
VALUES (1, 'Deposit 30%', CURRENT_DATE - INTERVAL '5 days', 45, 105, 'receipt001.jpg', 'pending');

INSERT INTO payment (bookingid, depopref, depopdate, paidamount, remamount, receipts, paystatus)
VALUES (2, 'Deposit 30%', CURRENT_DATE - INTERVAL '2 days', 180, 420, 'receipt002.jpg', 'pending');

INSERT INTO payment (bookingid, depopref, depopdate, paidamount, remamount, paystatus)
VALUES (3, 'Deposit 30%', CURRENT_DATE - INTERVAL '1 day', 60, 140, 'pending');

-- Sample Photo folder
INSERT INTO photo (folderlink, foldername, notesforclient, uploadedby)
VALUES ('https://drive.google.com/drive/folders/example123', 'Ali Family Photos Jan 2026', 'Photos available for 30 days. Please download and save.', 1);
UPDATE booking SET folderid = 1 WHERE bookingid = 1;

-- ============================================================
-- VERIFICATION
-- ============================================================
SELECT 'PHOTOGRAPHERS' AS DATA_TYPE, COUNT(*) AS COUNT FROM photographer
UNION ALL SELECT 'CLIENTS', COUNT(*) FROM client
UNION ALL SELECT 'PACKAGES', COUNT(*) FROM package
UNION ALL SELECT 'BOOKINGS', COUNT(*) FROM booking
UNION ALL SELECT 'PAYMENTS', COUNT(*) FROM payment
UNION ALL SELECT 'PHOTOS', COUNT(*) FROM photo;
