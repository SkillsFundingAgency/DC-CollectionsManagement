using System.Collections.Generic;
using ESFA.DC.CollectionsManagement.Models;

namespace ESFA.DC.CollectionsManagement.Interfaces
{
    public interface IOrganisationService
    {
        Organisation GetByUkprn(long ukprn);
        IEnumerable<CollectionType> GetAvailableCollectionTypes(long ukprn);
        IEnumerable<Collection> GetAvailableCollections(long ukprn, string collectionType);
    }
}
