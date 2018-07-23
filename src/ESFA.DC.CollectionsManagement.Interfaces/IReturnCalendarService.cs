using System.Threading.Tasks;
using ESFA.DC.CollectionsManagement.Models;

namespace ESFA.DC.CollectionsManagement.Services.Interface
{
    public interface IReturnCalendarService
    {
        Task<ReturnPeriod> GetCurrentPeriodAsync(string collectionName);
    }
}
