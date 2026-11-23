create or alter procedure silver.load_people
as
begin
	set nocount on;

	truncate table silver.people;

	insert into silver.people(
		person_id,
		person_name,
		person_type,
		city_id,
		age_group,
		gender,
		phone,
		registration_date,
		account_status,
		total_transactions
	)
	select
		cast(person_id as int),
		trim(person_name),
		trim(person_type),
		cast(city_id as int),
		trim(age_group),
		trim(gender),
		trim(phone),
		cast(registration_date as date),
		trim(account_status),
		cast(total_transactions as smallint)
	from bronze.people;
end;
go