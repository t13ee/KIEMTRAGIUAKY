using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace KIEMTRAGIUAKY.Models
{
    public class Enrollment
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string UserId { get; set; }

        public int CourseId { get; set; }

        public DateTime EnrollDate { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser? User { get; set; }

        [ForeignKey("CourseId")]
        public Course? Course { get; set; }
    }
}
