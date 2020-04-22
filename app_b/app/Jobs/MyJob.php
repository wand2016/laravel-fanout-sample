<?php

declare(strict_types=1);

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\Log;

/**
 * Example Job class
 */
class MyJob implements ShouldQueue
{
    use InteractsWithQueue, Queueable, SerializesModels;

    /**
     * @var string
     */
    private $subject;

    /**
     * @var array
     */
    private $payload;

    /**
     * @param string  $subject   SNS Subject
     * @param array   $payload   JSON decoded 'Message'
     */
    public function __construct(string $subject, array $payload)
    {
        $this->subject = $subject;
        $this->payload = $payload;
    }

    public function handle()
    {
        Log::info('--app b--');
        Log::info($this->subject, $this->payload);
    }
}
