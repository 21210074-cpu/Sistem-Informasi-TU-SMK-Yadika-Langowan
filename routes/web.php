<?php
use App\Livewire\Pages\Dashboard;
use Illuminate\Support\Facades\Route;
Route::get('/', function () {
    return view('welcome');
})->name('home');

Route::get('/create-admin', function () {
    $role = \App\Models\Role::where('name', 'admin')->first();
    \App\Models\User::create([
        'name' => 'Administrator',
        'email' => 'admin@smk.sch.id',
        'password' => bcrypt('password'),
        'email_verified_at' => now(),
        'role_id' => $role?->id,
    ]);
    return 'Admin created! Login with admin@smk.sch.id / password';
});

// Test route for Livewire debugging
Route::livewire('test-livewire', 'test-livewire')
    ->middleware(['auth', 'verified'])
    ->name('test.livewire');
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
