using System.Collections.Generic;
using System.Threading.Tasks;
using ESFA.DC.CollectionsManagement.Models;

namespace ESFA.DC.CollectionsManagement.Services.Interface
{
    public interface IOrganisationService
    {
        Organisation GetByUkprn(long ukprn);

        Task<IEnumerable<CollectionType>> GetAvailableCollectionTypesAsync(long ukprn);

        Task<IEnumerable<Collection>> GetAvailableCollectionsAsync(long ukprn, string collectionType);
    }
}
