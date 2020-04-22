<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use Aws\Sns\SnsClient;

class PublishController extends Controller
{
    /** @var SnsClient */
    private $client;

    /**
     * @param SnsClient $client
     */
    public function __construct(SnsClient $client)
    {
        $this->client = $client;
    }

    public function publish()
    {
        $subject = 'fanout example';
        $message = json_encode(['hola']);

        $this->client->publish([
            'Subject' => $subject,
            'Message' => $message,
            'TargetArn' => env('SNS_TOPIC_ARN'),
        ]);

        return sprintf('published "%s"', $message);
    }
}
