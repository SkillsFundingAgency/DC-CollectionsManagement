using ESFA.DC.CollectionsManagement.Models;

namespace ESFA.DC.CollectionsManagement.Interfaces
{
    public interface IRetrunCalendarService
    {
        ReturnPeriod GetCurrentPeriod(string collectionName);
    }
}
