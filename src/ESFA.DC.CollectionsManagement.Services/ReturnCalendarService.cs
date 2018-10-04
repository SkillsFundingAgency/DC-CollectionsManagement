using System;
using System.Linq;
using System.Threading.Tasks;
using ESFA.DC.CollectionsManagement.Data;
using ESFA.DC.CollectionsManagement.Models;
using ESFA.DC.CollectionsManagement.Services.Interface;
using ESFA.DC.DateTimeProvider.Interface;
using Microsoft.EntityFrameworkCore;

namespace ESFA.DC.CollectionsManagement.Services
{
    public class ReturnCalendarService : IReturnCalendarService, IDisposable
    {
        private readonly CollectionsManagementContext _collectionsManagementContext;
        private readonly IDateTimeProvider _dateTimeProvider;

        public ReturnCalendarService(DbContextOptions dbContextOptions, IDateTimeProvider dateTimeProvider)
        {
            _collectionsManagementContext = new CollectionsManagementContext(dbContextOptions);
            _dateTimeProvider = dateTimeProvider;
        }

        public async Task<ReturnPeriod> GetPeriodAsync(string collectionName, DateTime dateTimeUtc)
        {
            var data = await _collectionsManagementContext.ReturnPeriods.Include(x => x.Collection).Where(x =>
                    x.Collection.Name == collectionName &&
                    dateTimeUtc >= x.StartDateTimeUtc
                    && dateTimeUtc <= x.EndDateTimeUtc)
                .FirstOrDefaultAsync();
            if (data != null)
            {
                return Convert(data);
            }

            return null;
        }

        public async Task<ReturnPeriod> GetCurrentPeriodAsync(string collectionName)
        {
            var currentDateTime = _dateTimeProvider.GetNowUtc();
            return await GetPeriodAsync(collectionName, currentDateTime);
        }

        public async Task<ReturnPeriod> GetNextPeriodAsync(string collectionName)
        {
            var currentDateTime = _dateTimeProvider.GetNowUtc();
            var data = await _collectionsManagementContext.ReturnPeriods.Include(x => x.Collection).Where(x =>
                    x.Collection.Name == collectionName &&
                    x.StartDateTimeUtc > currentDateTime).OrderBy(x => x.StartDateTimeUtc)
                .FirstOrDefaultAsync();
            return Convert(data);
        }

        public ReturnPeriod Convert(Data.Entities.ReturnPeriod data)
        {
            if (data == null)
            {
                return null;
            }

            var period = new ReturnPeriod()
            {
                PeriodNumber = data.PeriodNumber,
                EndDateTimeUtc = data.EndDateTimeUtc,
                StartDateTimeUtc = data.StartDateTimeUtc,
                CalendarMonth = data.CalendarMonth,
                CalendarYear = data.CalendarYear,
                CollectionName = data.Collection.Name
            };
            return period;
        }

        public void Dispose()
        {
            _collectionsManagementContext.Dispose();
        }
    }
}
