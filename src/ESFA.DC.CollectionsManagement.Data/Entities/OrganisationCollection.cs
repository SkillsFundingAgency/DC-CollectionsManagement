namespace ESFA.DC.CollectionsManagement.Data.Entities
{
    public partial class OrganisationCollection
    {
        public int OrganisationId { get; set; }

        public int CollectionId { get; set; }

        public Collection Collection { get; set; }

        public Organisation Organisation { get; set; }
    }
}
