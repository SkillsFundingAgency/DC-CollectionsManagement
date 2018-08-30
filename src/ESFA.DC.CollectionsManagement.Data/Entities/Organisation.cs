using System.Collections.Generic;

namespace ESFA.DC.CollectionsManagement.Data.Entities
{
    public class Organisation
    {
        public Organisation()
        {
            OrganisationCollection = new HashSet<OrganisationCollection>();
        }

        public int OrganisationId { get; set; }

        public string OrgId { get; set; }

        public long Ukprn { get; set; }

        public string Name { get; set; }

        public string Email { get; set; }

        public ICollection<OrganisationCollection> OrganisationCollection { get; set; }
    }
}
