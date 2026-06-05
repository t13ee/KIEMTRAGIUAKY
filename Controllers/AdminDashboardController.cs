using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using KIEMTRAGIUAKY.Models;

namespace KIEMTRAGIUAKY.Controllers
{
    [Authorize(Roles = "Admin")]
    [Route("admin/dashboard")]
    public class AdminDashboardController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;

        public AdminDashboardController(ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        [Route("")]
        [Route("index")]
        public async Task<IActionResult> Index()
        {
            var totalCourses = await _context.Courses.CountAsync();
            var totalEnrollments = await _context.Enrollments.CountAsync();

            var studentUsers = await _userManager.GetUsersInRoleAsync("STUDENT");
            var totalStudents = studentUsers.Count;

            ViewData["TotalCourses"] = totalCourses;
            ViewData["TotalStudents"] = totalStudents;
            ViewData["TotalEnrollments"] = totalEnrollments;

            return View();
        }
    }
}
