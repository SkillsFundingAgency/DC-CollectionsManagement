using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using ESFA.DC.CollectionsManagement.Data;
using ESFA.DC.CollectionsManagement.Models;
using ESFA.DC.CollectionsManagement.Services.Interface;
using Microsoft.EntityFrameworkCore;

namespace ESFA.DC.CollectionsManagement.Services
{
    public class OrganisationService : IOrganisationService, IDisposable
    {
        private readonly CollectionsManagementContext _collectionsManagementContext;

        public OrganisationService(DbContextOptions dbContextOptions)
        {
            _collectionsManagementContext = new CollectionsManagementContext(dbContextOptions);
        }

        public async Task<IEnumerable<CollectionType>> GetAvailableCollectionTypesAsync(long ukprn)
        {
            var data = await _collectionsManagementContext.OrganisationCollections
                .Where(x => x.Organisation.Ukprn == ukprn)
                .GroupBy(x => x.Collection.CollectionType)
                .ToListAsync();
            var items = data.Select(y => new CollectionType()
            {
                Description = y.Key.Description,
                Type = y.Key.Type
            });

            return items;
        }

        public async Task<IEnumerable<Collection>> GetAvailableCollectionsAsync(long ukprn, string collectionType)
        {
            var data = await _collectionsManagementContext.OrganisationCollections
                .Include(x => x.Collection)
                .ThenInclude(x => x.CollectionType)
                .Where(x => x.Organisation.Ukprn == ukprn &&
                            x.Collection.IsOpen &&
                            x.Collection.CollectionType.Type == collectionType).
                ToListAsync();
            var items = data.Select(y => new Collection()
                {
                    CollectionTitle = y.Collection.Name,
                    IsOpen = y.Collection.IsOpen,
                    CollectionType = y.Collection.CollectionType.Type
                });

            return items;
        }

        public Organisation GetByUkprn(long ukprn)
        {
            throw new NotImplementedException();
        }

        public void Dispose()
        {
            _collectionsManagementContext.Dispose();
        }
    }
}
