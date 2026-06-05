using KIEMTRAGIUAKY.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using Microsoft.EntityFrameworkCore;

namespace KIEMTRAGIUAKY.Controllers
{
    public class HomeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public HomeController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string searchString, int? pageNumber)
        {
            ViewData["CurrentFilter"] = searchString;
            
            var courses = _context.Courses.Include(c => c.Category).AsNoTracking();

            if (!string.IsNullOrEmpty(searchString))
            {
                courses = courses.Where(c => c.Name.Contains(searchString));
            }

            int pageSize = 5;
            return View(await PaginatedList<Course>.CreateAsync(courses, pageNumber ?? 1, pageSize));
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
