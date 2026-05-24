<?php
use App\Livewire\Pages\Dashboard;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
})->name('home');

// SEMENTARA — hapus setelah berhasil login!
Route::get('/reset-admin', function () {
    $role = \App\Models\Role::where('name', 'admin')->first();
    \App\Models\User::updateOrCreate(
        ['email' => 'admin@smk.sch.id'],
        [
            'name' => 'Administrator',
            'password' => bcrypt('password'),
            'email_verified_at' => now(),
            'role_id' => $role?->id,
            'is_active' => true,
        ]
    );
    return 'Done! Login: admin@smk.sch.id / password — HAPUS route ini setelah login!';
});

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
