using System;

namespace ESFA.DC.CollectionsManagement.Data.Entities
{
    public class ReturnPeriod
    {
        public int ReturnPeriodId { get; set; }

        public DateTime StartDateTimeUtc { get; set; }

        public DateTime EndDateTimeUtc { get; set; }

        public int PeriodNumber { get; set; }

        public int CollectionId { get; set; }

        public int CalendarMonth { get; set; }

        public int CalendarYear { get; set; }

        public Collection Collection { get; set; }
    }
}
