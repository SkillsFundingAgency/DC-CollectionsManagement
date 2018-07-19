using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using ESFA.DC.CollectionsManagement.Data;
using ESFA.DC.CollectionsManagement.Data.Entities;
using ESFA.DC.CollectionsManagement.Models;
using ESFA.DC.DateTime.Provider.Interface;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using Xunit;

namespace ESFA.DC.CollectionsManagement.Services.Tests
{
    public class RetrunCalendarServiceTests
    {
        [Fact]
        public void Test_GetCurrentPeriod_Success()
        {
            var dbContextOptions = GetContextOptions();
            var dateTimeprovider = new Mock<IDateTimeProvider>();
            dateTimeprovider.Setup(x => x.GetNowUtc()).Returns(System.DateTime.UtcNow);

            var service = new ReturnCalendarService(dbContextOptions, dateTimeprovider.Object);

            SetupData(dbContextOptions);

            var result = service.GetCurrentPeriod("ILR1718");

            result.Should().NotBeNull();
            result.PeriodName.Should().Be("R12");
            result.CalendarMonth.Should().Be(7);
            result.CalendarYear.Should().Be(2018);
            result.CollectionName.Should().Be("ILR1718");
        }

        private void SetupData(DbContextOptions dbContextOptions)
        {
            using (var cmContext = new CollectionsManagementContext(dbContextOptions))
            {
                var collection = new Data.Entities.Collection()
                {
                    CollectionId = 1,
                    CollectionTypeId = 1,
                    IsOpen = true,
                    Name = "ILR1718"
                };
                cmContext.Collections.Add(collection);

                cmContext.ReturnPeriods.Add(new Data.Entities.ReturnPeriod()
                {
                    CalendarMonth = 8,
                    CalendarYear = 2018,
                    ReturnPeriodId = 2,
                    PeriodName = "R01",
                    StartDateTimeUtc = new System.DateTime(2018, 08, 22),
                    EndDateTimeUtc = new System.DateTime(2018, 09, 04),
                    Collection = collection,
                    CollectionId = 1,
                });

                cmContext.ReturnPeriods.Add(new Data.Entities.ReturnPeriod()
                {
                    CalendarMonth = 7,
                    CalendarYear = 2018,
                    ReturnPeriodId = 1,
                    PeriodName = "R12",
                    StartDateTimeUtc = System.DateTime.UtcNow.AddSeconds(-60),
                    EndDateTimeUtc = System.DateTime.UtcNow.AddSeconds(60),
                    Collection = collection,
                    CollectionId = 1
                });

                cmContext.SaveChanges();
            }
        }

        private DbContextOptions GetContextOptions([CallerMemberName]string functionName = "")
        {
            var serviceProvider = new ServiceCollection()
                .AddEntityFrameworkInMemoryDatabase()
                .BuildServiceProvider();

            var options = new DbContextOptionsBuilder<CollectionsManagementContext>()
                .UseInMemoryDatabase(functionName)
                .UseInternalServiceProvider(serviceProvider)
                .Options;
            return options;
        }
    }
}
