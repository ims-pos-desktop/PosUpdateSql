CREATE OR ALTER VIEW [dbo].[RMD_TRNMAIN_SYNC] WITH SCHEMABINDING
AS
SELECT  VCHRNO, DIVISION, CHALANNO, TRNDATE, BSDATE, TRNTIME, TOTAMNT, DCAMNT, DCRATE, VATAMNT, NETAMNT, ADVANCE, TRNMODE, BILLTO, BILLTOADD, TRNUSER, VATBILL, DELIVERYDATE, 
        DELIVERYTIME, ORDERS, REFORDBILL, INDDIS, CREBATE, CREDIT, DUEDATE, TRNAC, PARAC, PARTRNAMNT, RETTO, REFBILL, CHEQUENO, CHEQUEDATE, REMARKS, POST, POSTUSER, FPOSTUSER, 
        TERMINAL, SHIFT, EXPORT, CHOLDER, CARDNO, EditUser, MEMBERNO, MEMBERNAME, EDITED, TAXABLE, NONTAXABLE, VMODE, BILLTOTEL, BILLTOMOB, TRN_DATE, BS_DATE, STAX, TOTALCASH, 
        TOTALCREDIT, TOTALCREDITCARD, TOTALGIFTVOUCHER, TENDER, CHANGE, CardTranID, ReturnVchrID, TranID, VoucherStatus, VoucherType, PRESCRIBEBY, DISPENSEBY, RECEIVEBY, Edate, STATUS, 
        CONFIRMEDBY, CONFIRMEDTIME, PhiscalID, Stamp, ROUNDOFF, Customer_Count, DBUSER, HOSTID, VNUM, TOTALREBATE, DISVALUE, STAXVALUE, COSTCENTER, TOTALFLATDISCOUNT, TOTALINDDISCOUNT, 
        TOTALLOYALTY, TOTALPROMOTION, NETWITHOUTROUNDOFF, guid, JOBNO, MWAREHOUSE, POSTID, ORDERMODE, SALESMANID, ROW_VERSION
FROM    dbo.ABBMAIN							
						 
UNION ALL
SELECT  VCHRNO, DIVISION, CHALANNO, TRNDATE, BSDATE, TRNTIME, TOTAMNT, DCAMNT, DCRATE, VATAMNT, NETAMNT, ADVANCE, TRNMODE, BILLTO, BILLTOADD, TRNUSER, VATBILL, DELIVERYDATE, 
        DELIVERYTIME, ORDERS, REFORDBILL, INDDIS, CREBATE, CREDIT, DUEDATE, TRNAC, PARAC, PARTRNAMNT, RETTO, REFBILL, CHEQUENO, CHEQUEDATE, REMARKS, POST, POSTUSER, FPOSTUSER, 
        TERMINAL, SHIFT, EXPORT, CHOLDER, CARDNO, EditUser, MEMBERNO, MEMBERNAME, EDITED, TAXABLE, NONTAXABLE, VMODE, BILLTOTEL, BILLTOMOB, TRN_DATE, BS_DATE, STAX, TOTALCASH, 
        TOTALCREDIT, TOTALCREDITCARD, TOTALGIFTVOUCHER, TENDER, CHANGE, CardTranID, ReturnVchrID, TranID, VoucherStatus, VoucherType, PRESCRIBEBY, DISPENSEBY, RECEIVEBY, Edate, STATUS, 
        CONFIRMEDBY, CONFIRMEDTIME, PhiscalID, Stamp, ROUNDOFF, Customer_Count, DBUSER, HOSTID, VNUM, TOTALREBATE, DISVALUE, STAXVALUE, COSTCENTER, TOTALFLATDISCOUNT, TOTALINDDISCOUNT, 
        TOTALLOYALTY, TOTALPROMOTION, NETWITHOUTROUNDOFF, guid, JOBNO, MWAREHOUSE, POSTID, ORDERMODE, SALESMANID, ROW_VERSION
FROM    dbo.TRNMAIN   

UNION ALL
SELECT  VCHRNO, DIVISION, CHALANNO, TRNDATE, BSDATE, TRNTIME, TOTAMNT, DCAMNT, DCRATE, VATAMNT, NETAMNT, ADVANCE, TRNMODE, BILLTO, BILLTOADD, TRNUSER, VATBILL, DELIVERYDATE, 
        DELIVERYTIME, ORDERS, REFORDBILL, INDDIS, CREBATE, CREDIT, DUEDATE, TRNAC, PARAC, PARTRNAMNT, RETTO, REFBILL, CHEQUENO, CHEQUEDATE, REMARKS, POST, POSTUSER, FPOSTUSER, 
        TERMINAL, SHIFT, EXPORT, CHOLDER, CARDNO, EditUser, MEMBERNO, MEMBERNAME, EDITED, TAXABLE, NONTAXABLE, VMODE, BILLTOTEL, BILLTOMOB, TRN_DATE, BS_DATE, STAX, TOTALCASH, 
        TOTALCREDIT, TOTALCREDITCARD, TOTALGIFTVOUCHER, TENDER, CHANGE, CardTranID, ReturnVchrID, TranID, VoucherStatus, VoucherType, PRESCRIBEBY, DISPENSEBY, RECEIVEBY, Edate, STATUS, 
        CONFIRMEDBY, CONFIRMEDTIME, PhiscalID, Stamp, ROUNDOFF, Customer_Count, DBUSER, HOSTID, VNUM, TOTALREBATE, DISVALUE, STAXVALUE, COSTCENTER, TOTALFLATDISCOUNT, TOTALINDDISCOUNT, 
        TOTALLOYALTY, TOTALPROMOTION, NETWITHOUTROUNDOFF, guid, JOBNO, MWAREHOUSE, POSTID, ORDERMODE, SALESMANID, ROW_VERSION
FROM    dbo.ACCMAIN

UNION ALL
SELECT  VCHRNO, DIVISION, CHALANNO, TRNDATE, BSDATE, TRNTIME, TOTAMNT, DCAMNT, DCRATE, VATAMNT, NETAMNT, ADVANCE, TRNMODE, BILLTO, BILLTOADD, TRNUSER, VATBILL, DELIVERYDATE, 
        DELIVERYTIME, ORDERS, REFORDBILL, INDDIS, CREBATE, CREDIT, DUEDATE, TRNAC, PARAC, PARTRNAMNT, RETTO, REFBILL, CHEQUENO, CHEQUEDATE, REMARKS, POST, POSTUSER, FPOSTUSER, 
        TERMINAL, SHIFT, EXPORT, CHOLDER, CARDNO, EditUser, MEMBERNO, MEMBERNAME, EDITED, TAXABLE, NONTAXABLE, VMODE, BILLTOTEL, BILLTOMOB, TRN_DATE, BS_DATE, STAX, TOTALCASH, 
        TOTALCREDIT, TOTALCREDITCARD, TOTALGIFTVOUCHER, TENDER, CHANGE, CardTranID, ReturnVchrID, TranID, VoucherStatus, VoucherType, PRESCRIBEBY, DISPENSEBY, RECEIVEBY, Edate, STATUS, 
        CONFIRMEDBY, CONFIRMEDTIME, PhiscalID, Stamp, ROUNDOFF, Customer_Count, DBUSER, HOSTID, VNUM, TOTALREBATE, DISVALUE, STAXVALUE, COSTCENTER, TOTALFLATDISCOUNT, TOTALINDDISCOUNT, 
        TOTALLOYALTY, TOTALPROMOTION, NETWITHOUTROUNDOFF, guid, JOBNO, MWAREHOUSE, POSTID, ORDERMODE, SALESMANID, ROW_VERSION
FROM    dbo.INVMAIN

UNION ALL
SELECT  VCHRNO, DIVISION, CHALANNO, TRNDATE, BSDATE, TRNTIME, TOTAMNT, DCAMNT, DCRATE, VATAMNT, NETAMNT, ADVANCE, TRNMODE, BILLTO, BILLTOADD, TRNUSER, VATBILL, DELIVERYDATE, 
        DELIVERYTIME, ORDERS, REFORDBILL, INDDIS, CREBATE, CREDIT, DUEDATE, TRNAC, PARAC, PARTRNAMNT, RETTO, REFBILL, CHEQUENO, CHEQUEDATE, REMARKS, POST, POSTUSER, FPOSTUSER, 
        TERMINAL, SHIFT, EXPORT, CHOLDER, CARDNO, EditUser, MEMBERNO, MEMBERNAME, EDITED, TAXABLE, NONTAXABLE, VMODE, BILLTOTEL, BILLTOMOB, TRN_DATE, BS_DATE, STAX, TOTALCASH, 
        TOTALCREDIT, TOTALCREDITCARD, TOTALGIFTVOUCHER, TENDER, CHANGE, CardTranID, ReturnVchrID, TranID, VoucherStatus, VoucherType, PRESCRIBEBY, DISPENSEBY, RECEIVEBY, Edate, STATUS, 
        CONFIRMEDBY, CONFIRMEDTIME, PhiscalID, Stamp, ROUNDOFF, Customer_Count, DBUSER, HOSTID, VNUM, TOTALREBATE, DISVALUE, STAXVALUE, COSTCENTER, TOTALFLATDISCOUNT, TOTALINDDISCOUNT, 
        TOTALLOYALTY, TOTALPROMOTION, NETWITHOUTROUNDOFF, guid, JOBNO, MWAREHOUSE, POSTID, ORDERMODE, SALESMANID, ROW_VERSION
FROM    dbo.PURMAIN
                          
UNION ALL
SELECT  VCHRNO, DIVISION, CHALANNO, TRNDATE, BSDATE, TRNTIME, TOTAMNT, DCAMNT, DCRATE, VATAMNT, NETAMNT, ADVANCE, TRNMODE, BILLTO, BILLTOADD, TRNUSER, VATBILL, DELIVERYDATE, 
        DELIVERYTIME, ORDERS, REFORDBILL, INDDIS, CREBATE, CREDIT, DUEDATE, TRNAC, PARAC, PARTRNAMNT, RETTO, REFBILL, CHEQUENO, CHEQUEDATE, REMARKS, POST, POSTUSER, FPOSTUSER, 
        TERMINAL, SHIFT, EXPORT, CHOLDER, CARDNO, EditUser, MEMBERNO, MEMBERNAME, EDITED, TAXABLE, NONTAXABLE, VMODE, BILLTOTEL, BILLTOMOB, TRN_DATE, BS_DATE, STAX, TOTALCASH, 
        TOTALCREDIT, TOTALCREDITCARD, TOTALGIFTVOUCHER, TENDER, CHANGE, CardTranID, ReturnVchrID, TranID, VoucherStatus, VoucherType, PRESCRIBEBY, DISPENSEBY, RECEIVEBY, Edate, STATUS, 
        CONFIRMEDBY, CONFIRMEDTIME, PhiscalID, Stamp, ROUNDOFF, Customer_Count, DBUSER, HOSTID, VNUM, TOTALREBATE, DISVALUE, STAXVALUE, COSTCENTER, TOTALFLATDISCOUNT, TOTALINDDISCOUNT, 
        TOTALLOYALTY, TOTALPROMOTION, NETWITHOUTROUNDOFF, guid, JOBNO, MWAREHOUSE, POSTID, ORDERMODE, SALESMANID, ROW_VERSION					  
FROM    dbo.AOPMAIN

UNION ALL
SELECT  VCHRNO, DIVISION, CHALANNO, TRNDATE, BSDATE, TRNTIME, TOTAMNT, DCAMNT, DCRATE, VATAMNT, NETAMNT, ADVANCE, TRNMODE, BILLTO, BILLTOADD, TRNUSER, VATBILL, DELIVERYDATE, 
        DELIVERYTIME, ORDERS, REFORDBILL, INDDIS, CREBATE, CREDIT, DUEDATE, TRNAC, PARAC, PARTRNAMNT, RETTO, REFBILL, CHEQUENO, CHEQUEDATE, REMARKS, POST, POSTUSER, FPOSTUSER, 
        TERMINAL, SHIFT, EXPORT, CHOLDER, CARDNO, EditUser, MEMBERNO, MEMBERNAME, EDITED, TAXABLE, NONTAXABLE, VMODE, BILLTOTEL, BILLTOMOB, TRN_DATE, BS_DATE, STAX, TOTALCASH, 
        TOTALCREDIT, TOTALCREDITCARD, TOTALGIFTVOUCHER, TENDER, CHANGE, CardTranID, ReturnVchrID, TranID, VoucherStatus, VoucherType, PRESCRIBEBY, DISPENSEBY, RECEIVEBY, Edate, STATUS, 
        CONFIRMEDBY, CONFIRMEDTIME, PhiscalID, Stamp, ROUNDOFF, Customer_Count, DBUSER, HOSTID, VNUM, TOTALREBATE, DISVALUE, STAXVALUE, COSTCENTER, TOTALFLATDISCOUNT, TOTALINDDISCOUNT, 
        TOTALLOYALTY, TOTALPROMOTION, NETWITHOUTROUNDOFF, guid, JOBNO, MWAREHOUSE, POSTID, ORDERMODE, SALESMANID, ROW_VERSION						  
FROM    dbo.OPMAIN
