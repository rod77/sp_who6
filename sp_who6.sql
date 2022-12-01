create Procedure [dbo].[Sp_Who6]        
    @orderByDate int=0    
as        
set nocount on        
  
create table #Filtro (spId varchar(50), Status varchar(50), login varchar(50), hostname varchar(50),        
    blkby char(10), dbname varchar(50), command varchar(250), cputime varchar(50), diskio varchar(50),         
    lastbatch varchar(50) , programname varchar(250), spid2 varchar(50) ,requestid varchar(50),eventInfo varchar(max),loginame varchar(50))        
        
create table #Filtro2 (id int identity , spId varchar(50), Status varchar(50), login varchar(50), hostname varchar(50),        
    blkby char(10), dbname varchar(50), command varchar(250), cputime varchar(50), diskio varchar(50),         
    lastbatch varchar(50) , programname varchar(250), spid2 varchar(50) ,requestid varchar(50),eventInfo varchar(max),loginame varchar(50))   
            
Create table #Filtro3 (spid int, eventtype varchar(max), parameters varchar(55),eventInfo varchar(max))            
  
Create table #Filtro4 (spid int, ecid int, status varchar(50),loginame varchar(50),hostname varchar(128),blk int, dbname varchar(50),cmd varchar(16),request_id int)            
  
Insert into #Filtro4 ( spid,ecid,status,loginame,hostname,blk,dbname,cmd,request_id)        
execute SP_Who   
            
Insert into #Filtro (spId , Status, login , hostname ,blkby , dbname , command , cputime , diskio ,         
    lastbatch , programname, spid2,requestid)        
execute SP_Who3         
  
   
Insert into  #Filtro2        
Select  * from #Filtro  
where blkby!= '  .       '  
union  
Select a.* from #Filtro a  
inner join #Filtro b  
on a.spId=b.blkby  
  
update #Filtro2  
set loginame=b.loginame  
from #Filtro2 a  
inner join #Filtro4 b  
on a.spId = b.spid  
  
declare @min int, @max int, @spId int        
        
select @min = MIN(id), @max =max(Id) from #Filtro2        
        
declare @sql varchar(max)        
        
While @min <= @max        
begin         
 Select @spId = spId from #Filtro2 where id = @min         
 set @sql = 'dbcc inputbuffer('+convert(varchar(5),@spid)+')'        
 Insert into #Filtro3 (eventtype , parameters ,eventInfo )        
 exec (@sql)        
  
 Update #Filtro3        
 set spid = @spid        
 where spid is null        
         
 Update #Filtro2        
 set eventInfo = b.eventInfo        
 from #Filtro2 a        
 inner Join #Filtro3 b on a.spid = b.spid        
 where a.spid =@spid        
        
 set @min = @min + 1        
end    
      
if(@orderByDate=1)  
 Select * from #Filtro2  order by lastbatch  
else  
 Select * from #Filtro2   order by convert (int,spId) asc      