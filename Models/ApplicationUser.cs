using Microsoft.AspNetCore.Identity;

namespace KIEMTRAGIUAKY.Models
{
    public class ApplicationUser : IdentityUser
    {
        public ICollection<Enrollment>? Enrollments { get; set; }
    }
}
