using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using KIEMTRAGIUAKY.Models;

namespace KIEMTRAGIUAKY.Controllers
{
    [Authorize(Roles = "STUDENT")]
    [Route("enroll")]
    public class EnrollmentController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;

        public EnrollmentController(ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        [HttpPost("add/{courseId}")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Enroll(int courseId)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Challenge();

            // Kiểm tra xem đã đăng ký chưa
            var existing = await _context.Enrollments
                .FirstOrDefaultAsync(e => e.UserId == user.Id && e.CourseId == courseId);

            if (existing == null)
            {
                var enrollment = new Enrollment
                {
                    UserId = user.Id,
                    CourseId = courseId,
                    EnrollDate = DateTime.Now
                };
                _context.Enrollments.Add(enrollment);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(MyCourses));
        }

        [HttpPost("cancel/{courseId}")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Cancel(int courseId)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Challenge();

            var enrollment = await _context.Enrollments
                .FirstOrDefaultAsync(e => e.UserId == user.Id && e.CourseId == courseId);

            if (enrollment != null)
            {
                _context.Enrollments.Remove(enrollment);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(MyCourses));
        }

        [HttpGet("my-courses")]
        public async Task<IActionResult> MyCourses()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Challenge();

            var enrollments = await _context.Enrollments
                .Include(e => e.Course)
                .ThenInclude(c => c.Category)
                .Where(e => e.UserId == user.Id)
                .ToListAsync();

            return View(enrollments);
        }
    }
}
