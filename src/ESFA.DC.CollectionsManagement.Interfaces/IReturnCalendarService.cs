using ESFA.DC.CollectionsManagement.Models;

namespace ESFA.DC.CollectionsManagement.Services.Interface
{
    public interface IReturnCalendarService
    {
        ReturnPeriod GetCurrentPeriod(string collectionName);
    }
}
