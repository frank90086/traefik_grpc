using Microsoft.AspNetCore.Mvc;
using Grpc.Net.Client;
using Hello.Grpc.WebAPI;

namespace Hello.Grpc.WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };
    private readonly Greeter.GreeterClient _client;

    private readonly ILogger<WeatherForecastController> _logger;

    public WeatherForecastController(ILogger<WeatherForecastController> logger, Greeter.GreeterClient client)
    {
        _logger = logger;
        _client = client;
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        return NoContent();
    }

    [HttpGet("{str}")]
    public async Task<IActionResult> Get(string str)
    {
        AppContext.SetSwitch("System.Net.Http.SocketsHttpHandler.Http2UnencryptedSupport", true);
        AppContext.SetSwitch("System.Net.Http.SocketsHttpHandler.Http2Support", true);

        // var handler = new SubdirectoryHandler(new HttpClientHandler(), "/grpc");
        // using var channel = GrpcChannel.ForAddress(ServerAddress, new GrpcChannelOptions { HttpHandler = handler });
        // var client = new Greeter.GreeterClient(channel);
        var reply = await _client.SayHelloAsync(new HelloRequest { Name = str });
        return Ok(reply.Message);
    }
}
