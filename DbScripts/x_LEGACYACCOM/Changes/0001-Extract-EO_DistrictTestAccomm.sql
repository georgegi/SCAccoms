if object_id('x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL') is not null
drop table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL
go

create table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL (
IEPRefID	int not null,
SubRefID	int not null,
DistAssesstitle varchar(100)  null,
Participation varchar(max) null, -- this is a GUID, but we treat as varchar for a reason (union all with values view)
Accommodations text NULL,
Sequence int not null
)

alter table x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL 
	add constraint PK_x_LEGACYACCOM_EO_DistrictTestAccomm_LOCAL primary key (SubRefID)
go

create index IX_x_LEGACYACCOM_EO_DistrictTestAccomm_LOCAL_IEPComplSeqNum on x_LEGACYACCOM.EO_DistrictTestAccomm_LOCAL (IEPRefID)
go
