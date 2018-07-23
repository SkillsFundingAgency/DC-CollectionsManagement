using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ESFA.DC.CollectionsManagement.Data;
using ESFA.DC.CollectionsManagement.Models;
using ESFA.DC.CollectionsManagement.Services.Interface;
using ESFA.DC.DateTime.Provider.Interface;
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

        public async Task<ReturnPeriod> GetCurrentPeriodAsync(string collectionName)
        {
            var currentDateTime = _dateTimeProvider.GetNowUtc();
            var data = await _collectionsManagementContext.ReturnPeriods.Where(x =>
                    x.Collection.Name == collectionName &&
                    currentDateTime >= x.StartDateTimeUtc
                    && currentDateTime <= x.EndDateTimeUtc)
                    .FirstOrDefaultAsync();
            if (data != null)
            {
                var period = new ReturnPeriod()
                {
                    PeriodName = data.PeriodName,
                    EndDateTimeUtc = data.EndDateTimeUtc,
                    StartDateTimeUtc = data.StartDateTimeUtc,
                    CalendarMonth = data.CalendarMonth,
                    CalendarYear = data.CalendarYear,
                    CollectionName = data.Collection.Name
                };
                return period;
            }

            return null;
        }

        public void Dispose()
        {
            _collectionsManagementContext.Dispose();
        }
    }
}
