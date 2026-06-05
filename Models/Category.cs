using System.ComponentModel.DataAnnotations;

namespace KIEMTRAGIUAKY.Models
{
    public class Category
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        // Navigation property
        public ICollection<Course>? Courses { get; set; }
    }
}
