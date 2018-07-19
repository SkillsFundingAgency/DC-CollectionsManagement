using ESFA.DC.CollectionsManagement.Data.Entities;
using Microsoft.EntityFrameworkCore;

namespace ESFA.DC.CollectionsManagement.Data
{
    public partial class CollectionsManagementContext : DbContext
    {
        public CollectionsManagementContext()
        {
        }

        public CollectionsManagementContext(DbContextOptions options)
            : base(options)
        {
        }

        public virtual DbSet<Collection> Collection { get; set; }

        public virtual DbSet<Collection> Collections { get; set; }

        public virtual DbSet<CollectionType> CollectionTypes { get; set; }

        public virtual DbSet<Organisation> Organisations { get; set; }

        public virtual DbSet<OrganisationCollection> OrganisationCollections { get; set; }

        public virtual DbSet<ReturnPeriod> ReturnPeriods { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Collection>(entity =>
            {
                entity.Property(e => e.CollectionId).ValueGeneratedNever();
                entity.ToTable("Collection");
                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<CollectionType>(entity =>
            {
                entity.Property(e => e.CollectionTypeId).ValueGeneratedNever();
                entity.ToTable("CollectionType");
                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.Type)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Organisation>(entity =>
            {
                entity.Property(e => e.OrganisationId).ValueGeneratedNever();
                entity.ToTable("Organisation");
                entity.Property(e => e.Email)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.OrgId)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganisationCollection>(entity =>
            {
                entity.HasKey(e => new { e.OrganisationId, e.CollectionId });
                entity.ToTable("OrganisationCollection");
                entity.HasOne(d => d.Collection)
                    .WithMany(p => p.OrganisationCollection)
                    .HasForeignKey(d => d.CollectionId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_OrganisationCollection_Collection");

                entity.HasOne(d => d.Organisation)
                    .WithMany(p => p.OrganisationCollection)
                    .HasForeignKey(d => d.OrganisationId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_OrganisationCollection_Organisation");
            });

            modelBuilder.Entity<ReturnPeriod>(entity =>
            {
                entity.Property(e => e.ReturnPeriodId).ValueGeneratedNever();
                entity.ToTable("ReturnPeriod");

                entity.Property(e => e.EndDateTimeUtc)
                    .HasColumnName("EndDateTimeUTC")
                    .HasColumnType("datetime");

                entity.Property(e => e.PeriodName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.StartDateTimeUtc)
                    .HasColumnName("StartDateTimeUTC")
                    .HasColumnType("datetime");

                entity.HasOne(d => d.Collection)
                    .WithMany(p => p.ReturnPeriod)
                    .HasForeignKey(d => d.CollectionId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ReturnPeriod_Collection");
            });
        }
    }
}
