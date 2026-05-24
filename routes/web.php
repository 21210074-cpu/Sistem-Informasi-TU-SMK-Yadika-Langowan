<?php
use App\Livewire\Pages\Dashboard;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
})->name('home');

// HAPUS route reset-admin ini setelah berhasil login!
// Route::get('/reset-admin', ...);

Route::livewire('dashboard', Dashboard::class)
    ->middleware(['auth', 'verified'])
    ->name('dashboard');

require __DIR__.'/settings.php';
require __DIR__.'/master.php';
require __DIR__.'/employee.php';
require __DIR__.'/student.php';
require __DIR__.'/admin.php';
require __DIR__.'/parent.php';
require __DIR__.'/student-portal.php';
require __DIR__.'/academic.php';
require __DIR__.'/inventory.php';
require __DIR__.'/finance.php';
