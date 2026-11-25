USE FoodMarket;
GO

create or alter procedure dbo.run_etl_pipeline
as
begin
	set nocount on;

	begin try
		print 'Starting pipeline';

		exec bronze.load_all
			@folder_path = 'C:\Users\masa.gacevic\Desktop\DA_intern';

		print 'Bronze layer added';

		exec silver.load_all;

		print 'Silver layer added';
	end try
	begin catch
		
		print 'ETL pipeline failed';
		throw;
	end catch
end;
go

exec dbo.run_etl_pipeline;