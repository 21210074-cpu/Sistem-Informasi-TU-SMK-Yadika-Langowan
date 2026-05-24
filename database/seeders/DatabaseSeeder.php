<?php
namespace Database\Seeders;

use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call(RolePermissionSeeder::class);
        $this->call(PositionSeeder::class);

        $adminRole = Role::where('name', Role::ADMIN)->first();

        $adminUser = User::where('email', 'admin@smk.sch.id')->first();
        if ($adminUser === null) {
            User::create([
                'name' => 'Administrator',
                'email' => 'admin@smk.sch.id',
                'password' => Hash::make('password'),
                'email_verified_at' => now(),
                'role_id' => $adminRole?->id,
                'is_active' => true,
            ]);
        } else {
            $adminUser->update([
                'name' => 'Administrator',
                'role_id' => $adminRole?->id,
                'is_active' => true,
            ]);
        }

        $roles = Role::where('name', '!=', Role::ADMIN)->get();
        foreach ($roles as $role) {
            $email = strtolower(str_replace('_', '.', $role->name)).'@smk.sch.id';
            $existingUser = User::where('email', $email)->first();
            if ($existingUser === null) {
                User::create([
                    'name' => 'User '.$role->display_name,
                    'email' => $email,
                    'password' => Hash::make('password'),
                    'email_verified_at' => now(),
                    'role_id' => $role->id,
                    'is_active' => true,
                ]);
            } else {
                $existingUser->update([
                    'name' => 'User '.$role->display_name,
                    'role_id' => $role->id,
                    'is_active' => true,
                ]);
            }
        }

        if (\App\Models\IncomingLetter::count() === 0) {
            $this->call(IncomingLetterSeeder::class);
        }
        if (\App\Models\OutgoingLetter::count() === 0) {
            $this->call(OutgoingLetterSeeder::class);
        }
    }
}
