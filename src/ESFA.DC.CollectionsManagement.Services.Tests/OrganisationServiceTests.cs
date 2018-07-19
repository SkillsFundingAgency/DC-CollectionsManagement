using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using ESFA.DC.CollectionsManagement.Data;
using ESFA.DC.CollectionsManagement.Data.Entities;
using ESFA.DC.CollectionsManagement.Models;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace ESFA.DC.CollectionsManagement.Services.Tests
{
    public class OrganisationServiceTests
    {
        [Fact]
        public void Test_GetAvailableCollectionTypes_NoCollectionFound()
        {
            var dbContextOptions = GetContextOptions();
            var service = new OrganisationService(dbContextOptions);

            SetupData(dbContextOptions);

            var result = service.GetAvailableCollectionTypes(99999).ToList();

            result.Should().NotBeNull();
            result.Count.Should().Be(0);
        }

        [Fact]
        public void Test_GetAvailableCollectionTypes_Success()
        {
            var dbContextOptions = GetContextOptions();
            var service = new OrganisationService(dbContextOptions);

            SetupData(dbContextOptions);

            var result = service.GetAvailableCollectionTypes(1000).ToList();

            result.Should().NotBeNull();
            result.Count.Should().Be(1);
            result[0].Description.Should().Be("ILR collection");
            result[0].Type.Should().Be("ILR");
        }

        [Fact]
        public void Test_GetAvailableCollections_NotFound_CollectionType()
        {
            var dbContextOptions = GetContextOptions();
            var service = new OrganisationService(dbContextOptions);

            SetupData(dbContextOptions);

            var result = service.GetAvailableCollections(1000, "EAS011").ToList();

            result.Should().NotBeNull();
            result.Count.Should().Be(0);
        }

        [Fact]
        public void Test_GetAvailableCollections_NotFound_Ukprn()
        {
            var dbContextOptions = GetContextOptions();
            var service = new OrganisationService(dbContextOptions);

            SetupData(dbContextOptions);

            var result = service.GetAvailableCollections(99999, "ILR").ToList();

            result.Should().NotBeNull();
            result.Count.Should().Be(0);
        }

        [Fact]
        public void Test_GetAvailableCollections_Success()
        {
            var dbContextOptions = GetContextOptions();
            var service = new OrganisationService(dbContextOptions);

            SetupData(dbContextOptions);

            var result = service.GetAvailableCollections(1000, "ILR").ToList();

            result.Should().NotBeNull();
            result.Count.Should().Be(1);
            result[0].CollectionType.Should().Be("ILR");
            result[0].IsOpen.Should().Be(true);
            result[0].CollectionTitle.Should().Be("test coll");
        }

        private void SetupData(DbContextOptions dbContextOptions)
        {
            using (var cmContext = new CollectionsManagementContext(dbContextOptions))
            {
                cmContext.Organisations.Add(new Data.Entities.Organisation()
                {
                    Ukprn = 1000,
                    OrgId = "test_org1",
                    OrganisationId = 1
                });

                cmContext.Collections.Add(new Data.Entities.Collection()
                {
                    CollectionId = 1,
                    CollectionTypeId = 1,
                    IsOpen = true,
                    Name = "test coll"
                });

                cmContext.Collections.Add(new Data.Entities.Collection()
                {
                    CollectionId = 2,
                    CollectionTypeId = 1,
                    IsOpen = true,
                    Name = "test coll2"
                });

                cmContext.CollectionTypes.Add(new Data.Entities.CollectionType()
                {
                    CollectionTypeId = 1,
                    Description = "ILR collection",
                    Type = "ILR"
                });

                cmContext.OrganisationCollections.Add(new OrganisationCollection()
                {
                    CollectionId = 1,
                    OrganisationId = 1
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
